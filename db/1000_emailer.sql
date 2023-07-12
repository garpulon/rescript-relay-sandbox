CREATE OR REPLACE FUNCTION app_public.send_simple_email(email citext, subject text, body text, html text)
    RETURNS bool
    AS $$
DECLARE
    trimmedEmail text;
    v_state text;
    v_msg text;
    v_detail text;
    v_hint text;
    v_context text;
BEGIN
    SELECT
        trim(email) INTO trimmedEmail;
    IF trimmedEmail IS NULL THEN
        PERFORM
            app_private.raise_client_message('warn', '{"email"}', 'no email address provided');
        RETURN FALSE;
    END IF;
    IF trimmedEmail !~* '^[A-Za-z0-9._%-]+@[A-Za-z0-9.-]+[.][A-Za-z]+$' THEN
        PERFORM
            app_private.raise_client_message('warn', '{"email"}', 'invalid email address');
        RETURN FALSE;
    END IF;
    PERFORM
        graphile_worker.add_job('sendgrid_single.bs'::text, json_build_object('to', trimmedEmail, 'from', 'test@jococruise.com', 'subject', subject, 'text', body, 'html', html)::json);
    RETURN TRUE;
EXCEPTION
    WHEN OTHERS THEN
        get stacked diagnostics v_state = returned_sqlstate,
        v_msg = message_text,
        v_detail = pg_exception_detail,
        v_hint = pg_exception_hint,
        v_context = pg_exception_context;
    RAISE NOTICE E'Got exception:
        state  : %
        message: %
        detail : %
        hint   : %
        context: %', v_state, v_msg, v_detail, v_hint, v_context;
    RAISE NOTICE E'Got exception:
        SQLSTATE: % 
        SQLERRM: %', SQLSTATE, SQLERRM;
    RAISE NOTICE '%', v_msg;
    PERFORM
        app_private.raise_client_message('warn', '{"general_error"}', 'general error');
    RETURN FALSE;
END;

$$
LANGUAGE plpgsql
SECURITY DEFINER;

