CREATE FUNCTION app_public.current_user_id()
  RETURNS text
  AS $$
  SELECT
    nullif(current_setting('jwt.claims.email', TRUE), '')::text;
$$
LANGUAGE sql
STABLE SET search_path
FROM
  CURRENT;

COMMENT ON FUNCTION app_public.current_user_id() IS E'@omit\nHandy method to get the current user ID for use in RLS policies, etc; in GraphQL, use `currentUser{id}` instead.';

------------------------------------------------
-- keep this all separate
-- inspired by https://postgrest.org/en/stable/how-tos/sql-user-management.html#sql-user-management
CREATE SCHEMA IF NOT EXISTS basic_auth;

CREATE EXTENSION IF NOT EXISTS pgcrypto;

-------------------------------------------------------------------------------
-- First we’ll need a table to keep track of our users:
CREATE TABLE IF NOT EXISTS basic_auth.users(
  email citext PRIMARY KEY CHECK (email ~* '^.+@.+\..+$'),
  pass text NOT NULL CHECK (length(pass) < 512),
  role name NOT NULL CHECK (length(ROLE) < 512),
  is_admin bool NOT NULL DEFAULT FALSE
);

-- this view could use some love
CREATE OR REPLACE VIEW app_public.users AS
SELECT
  email,
  is_admin,
  'https://placekitten.com/100/100' AS avatar_url
FROM
  basic_auth.users;

COMMENT ON COLUMN app_public.users.email IS E'@notNull';

COMMENT ON COLUMN app_public.users.is_admin IS E'@notNull';

CREATE FUNCTION app_public.current_user ()
  RETURNS app_public.users
  AS $$
  SELECT
    users.*
  FROM
    app_public.users
  WHERE
    email = app_public.current_user_id();
$$
LANGUAGE sql
STABLE SET search_path
FROM
  CURRENT;

CREATE FUNCTION app_public.current_user_is_admin()
  RETURNS bool
  AS $$
  -- We're using exists here because it guarantees true/false rather than true/false/null
  SELECT
    EXISTS(
      SELECT
        1
      FROM
        basic_auth.users
      WHERE
        email = app_public.current_user_id()
        AND is_admin = TRUE);
$$
LANGUAGE sql
STABLE SET search_path
FROM
  CURRENT
  SECURITY DEFINER;

-- We would like the role to be a foreign key to actual database roles, however PostgreSQL does not support these constraints against the pg_roles table. We’ll use a trigger to manually enforce it.
CREATE OR REPLACE FUNCTION basic_auth.check_role_exists()
  RETURNS TRIGGER
  AS $$
BEGIN
  IF NOT EXISTS(
    SELECT
      1
    FROM
      pg_roles AS r
    WHERE
      r.rolname = NEW.role) THEN
  RAISE foreign_key_violation
  USING message = 'unknown database role: ' || NEW.role;
  RETURN NULL;
END IF;
  RETURN new;
END
$$
LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS ensure_user_role_exists ON basic_auth.users;

CREATE CONSTRAINT TRIGGER ensure_user_role_exists
  AFTER INSERT OR UPDATE ON basic_auth.users FOR EACH ROW
  EXECUTE PROCEDURE basic_auth.check_role_exists();

-- Next we’ll use the pgcrypto extension and a trigger to keep passwords safe in the users table.
CREATE OR REPLACE FUNCTION basic_auth.encrypt_pass()
  RETURNS TRIGGER
  AS $$
BEGIN
  IF tg_op = 'INSERT' OR NEW.pass <> OLD.pass THEN
    NEW.pass = crypt(NEW.pass, gen_salt('bf'));
  END IF;
  RETURN new;
END
$$
LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS encrypt_pass ON basic_auth.users;

CREATE TRIGGER encrypt_pass
  BEFORE INSERT OR UPDATE ON basic_auth.users FOR EACH ROW
  EXECUTE PROCEDURE basic_auth.encrypt_pass();

-- With the table in place we can make a helper to check a password against the encrypted column. It returns the database role for a user if the email and password are correct.
CREATE OR REPLACE FUNCTION basic_auth.user_role(email text, pass text)
  RETURNS name
  LANGUAGE plpgsql
  AS $$
BEGIN
  RETURN(
    SELECT
      ROLE
    FROM
      basic_auth.users
    WHERE
      users.email = trim(user_role.email)
      AND users.pass = crypt(user_role.pass, users.pass));
END;
$$;

-------------------------------------------------------------------------------------
-- add type
CREATE TYPE app_public.jwt_token AS (
  ROLE text,
  email text,
  exp integer
);

CREATE OR REPLACE FUNCTION app_private.raise_client_message(_level text, _paths text[], _msg text)
  RETURNS void
  AS $$
BEGIN
  RAISE NOTICE '%', _msg
  USING errcode = 'OPMSG', detail = json_build_object('level', _level, 'path', _paths)::text RETURN;
END;
$$
LANGUAGE plpgsql
SECURITY DEFINER;

-- this should not be in a file
-- ALTER DATABASE relaysandbox SET "basic_auth.jwt_secret" TO 'asecretfortesting';
-- login should be on your exposed schema
CREATE OR REPLACE FUNCTION app_public.login(email text, pass text)
  RETURNS app_public.jwt_token
  AS $$
DECLARE
  _role name;
  result app_public.jwt_token;
BEGIN
  -- check email and password
  SELECT
    basic_auth.user_role(email, pass) INTO _role;
  IF _role IS NULL THEN
    PERFORM
      app_private.raise_client_message('warn', '{"email", "pass"}', 'invalid user name or password');
    SELECT
      NULL INTO result;
    RETURN result;
  END IF;
  SELECT
    _role,
    login.email,
    extract(epoch FROM now())::integer + 60 * 60 INTO result;
  RETURN result;
END;
$$
LANGUAGE plpgsql
SECURITY DEFINER;

-- login should be on your exposed schema
CREATE OR REPLACE FUNCTION app_public.register(email text, pass text)
  RETURNS bool
  AS $$
DECLARE
  extantEmail text;
BEGIN
  -- check email and password
  SELECT
    t.email
  FROM
    basic_auth.users t
  WHERE
    t.email = trim(register.email) INTO extantEmail;
  IF extantEmail IS NOT NULL THEN
    PERFORM
      app_private.raise_client_message('warn', '{"email"}', 'cannot create an account with this email address');
    RETURN FALSE;
  END IF;
  IF length(pass) < 8 THEN
    PERFORM
      app_private.raise_client_message('warn', '{"password"}', 'password must be at least 8 chars in length');
    RETURN FALSE;
  END IF;
  INSERT INTO basic_auth.users
  VALUES (
    email,
    pass,
    'loggedin');
  RETURN TRUE;
END;
$$
LANGUAGE plpgsql
SECURITY DEFINER;

