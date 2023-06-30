CREATE FUNCTION app_private.tg__add_job_for_row()
  RETURNS TRIGGER
  AS $$
BEGIN
  PERFORM
    app_jobs.add_job(tg_argv[0], json_build_object('id', NEW.id));
  RETURN NEW;
END;
$$
LANGUAGE plpgsql
SET search_path
FROM
  CURRENT;

COMMENT ON FUNCTION app_private.tg__add_job_for_row() IS E'Useful shortcut to create a job on insert or update. Pass the task name as the trigger argument, and the record id will automatically be available on the JSON payload.';

--------------------------------------------------------------------------------
CREATE FUNCTION app_private.tg__update_timestamps()
  RETURNS TRIGGER
  AS $$
BEGIN
  NEW.created_at =(
    CASE WHEN TG_OP = 'INSERT' THEN
      NOW()
    ELSE
      OLD.created_at
    END);
  NEW.updated_at =(
    CASE WHEN TG_OP = 'UPDATE'
      AND OLD.updated_at >= NOW() THEN
      OLD.updated_at + interval '1 millisecond'
    ELSE
      NOW()
    END);
  RETURN NEW;
END;
$$
LANGUAGE plpgsql
VOLATILE SET search_path
FROM
  CURRENT;

COMMENT ON FUNCTION app_private.tg__update_timestamps() IS E'This trigger should be called on all tables with created_at, updated_at - it ensures that they cannot be manipulated and that updated_at will always be larger than the previous updated_at.';

