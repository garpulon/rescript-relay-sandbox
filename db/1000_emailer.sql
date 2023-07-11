DROP FUNCTION IF EXISTS app_public.send_simple_email(email citext, subject text, body text, html text);

CREATE FUNCTION app_public.send_simple_email(email citext, subject text, body text, html text)
    RETURNS bool
    AS $$
DECLARE
    trimmedEmail text;
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
            app_private.raise_client_message('warn', '{"email"}', 'oops invalid email address');
        RETURN FALSE;
    END IF;
    SELECT
        graphile_worker.add_job('sendgrid_single.bs', json_build_object('to', trimmedEmail, 'from', 'test@jococruise.com', 'subject', subject, 'text', body, 'html', html)::text);
    RETURN TRUE;
EXCEPTION
    WHEN OTHERS THEN
        PERFORM
            app_private.raise_client_message('warn', '{"general_error"}', 'invalid email address');
    RETURN FALSE;
END;

$$
LANGUAGE plpgsql;

