--------------------------------------------------------------------------------
CREATE TABLE app_public.users(
  id serial PRIMARY KEY,
  username citext NOT NULL UNIQUE CHECK (username ~ '^[a-zA-Z]([a-zA-Z0-9][_]?)+$'),
  name text,
  avatar_url text CHECK (avatar_url ~ '^https?://[^/]+'),
  is_admin boolean NOT NULL DEFAULT FALSE,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now()
);

ALTER TABLE app_public.users ENABLE ROW LEVEL SECURITY;

CREATE TRIGGER _100_timestamps
  BEFORE INSERT OR UPDATE ON app_public.users FOR EACH ROW
  EXECUTE PROCEDURE app_private.tg__update_timestamps();

-- By doing `@omit all` we prevent the `allUsers` field from appearing in our
-- GraphQL schema.  User discovery is still possible by browsing the rest of
-- the data, but it makes it harder for people to receive a `totalCount` of
-- users, or enumerate them fully.
COMMENT ON TABLE app_public.users IS E'@omit all\nA user who can log in to the application.';

COMMENT ON COLUMN app_public.users.id IS E'Unique identifier for the user.';

COMMENT ON COLUMN app_public.users.username IS E'Public-facing username (or ''handle'') of the user.';

COMMENT ON COLUMN app_public.users.name IS E'Public-facing name (or pseudonym) of the user.';

COMMENT ON COLUMN app_public.users.avatar_url IS E'Optional avatar URL.';

COMMENT ON COLUMN app_public.users.is_admin IS E'If true, the user has elevated privileges.';

CREATE POLICY select_all ON app_public.users
  FOR SELECT
    USING (TRUE);

CREATE POLICY update_self ON app_public.users
  FOR UPDATE
    USING (id = app_public.current_user_id());

CREATE POLICY delete_self ON app_public.users
  FOR DELETE
    USING (id = app_public.current_user_id());

GRANT SELECT ON app_public.users TO graphiledemo_visitor;

GRANT UPDATE (name, avatar_url) ON app_public.users TO graphiledemo_visitor;

GRANT DELETE ON app_public.users TO graphiledemo_visitor;

CREATE FUNCTION app_private.tg_users__make_first_user_admin()
  RETURNS TRIGGER
  AS $$
BEGIN
  IF NOT EXISTS(
    SELECT
      1
    FROM
      app_public.users) THEN
  NEW.is_admin = TRUE;
END IF;
  RETURN NEW;
END;
$$
LANGUAGE plpgsql
VOLATILE SET search_path
FROM
  CURRENT;

CREATE TRIGGER _200_make_first_user_admin
  BEFORE INSERT ON app_public.users FOR EACH ROW
  EXECUTE PROCEDURE app_private.tg_users__make_first_user_admin();

--------------------------------------------------------------------------------
CREATE FUNCTION app_public.current_user_is_admin()
  RETURNS bool
  AS $$
  -- We're using exists here because it guarantees true/false rather than true/false/null
  SELECT
    EXISTS(
      SELECT
        1
      FROM
        app_public.users
      WHERE
        id = app_public.current_user_id()
        AND is_admin = TRUE);
$$
LANGUAGE sql
STABLE SET search_path
FROM
  CURRENT;

COMMENT ON FUNCTION app_public.current_user_is_admin() IS E'@omit\nHandy method to determine if the current user is an admin, for use in RLS policies, etc; in GraphQL should use `currentUser{isAdmin}` instead.';

--------------------------------------------------------------------------------
CREATE FUNCTION app_public.current_user ()
  RETURNS app_public.users
  AS $$
  SELECT
    users.*
  FROM
    app_public.users
  WHERE
    id = app_public.current_user_id();
$$
LANGUAGE sql
STABLE SET search_path
FROM
  CURRENT;

--------------------------------------------------------------------------------
CREATE TABLE app_private.user_secrets(
  user_id int NOT NULL PRIMARY KEY REFERENCES app_public.users ON DELETE CASCADE,
  password_hash text,
  password_attempts int NOT NULL DEFAULT 0,
  first_failed_password_attempt timestamptz,
  reset_password_token text,
  reset_password_token_generated timestamptz,
  reset_password_attempts int NOT NULL DEFAULT 0,
  first_failed_reset_password_attempt timestamptz
);

COMMENT ON TABLE app_private.user_secrets IS E'The contents of this table should never be visible to the user. Contains data mostly related to authentication.';

CREATE FUNCTION app_private.tg_user_secrets__insert_with_user()
  RETURNS TRIGGER
  AS $$
BEGIN
  INSERT INTO app_private.user_secrets(
    user_id)
  VALUES(
    NEW.id);
  RETURN NEW;
END;
$$
LANGUAGE plpgsql
VOLATILE SET search_path
FROM
  CURRENT;

CREATE TRIGGER _500_insert_secrets
  AFTER INSERT ON app_public.users FOR EACH ROW
  EXECUTE PROCEDURE app_private.tg_user_secrets__insert_with_user();

COMMENT ON FUNCTION app_private.tg_user_secrets__insert_with_user() IS E'Ensures that every user record has an associated user_secret record.';

--------------------------------------------------------------------------------
CREATE TABLE app_public.user_emails(
  id serial PRIMARY KEY,
  user_id int NOT NULL DEFAULT app_public.current_user_id() REFERENCES app_public.users ON DELETE CASCADE,
  email citext NOT NULL CHECK (email ~ '[^@]+@[^@]+\.[^@]+'),
  is_verified boolean NOT NULL DEFAULT FALSE,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now(),
  UNIQUE (user_id, email)
);

CREATE UNIQUE INDEX uniq_user_emails_verified_email ON app_public.user_emails(email)
WHERE
  is_verified IS TRUE;

ALTER TABLE app_public.user_emails ENABLE ROW LEVEL SECURITY;

CREATE TRIGGER _100_timestamps
  BEFORE INSERT OR UPDATE ON app_public.user_emails FOR EACH ROW
  EXECUTE PROCEDURE app_private.tg__update_timestamps();

CREATE TRIGGER _900_send_verification_email
  AFTER INSERT ON app_public.user_emails FOR EACH ROW
  WHEN(NEW.is_verified IS FALSE)
  EXECUTE PROCEDURE app_private.tg__add_job_for_row('user_emails__send_verification');

-- `@omit all` because there's no point exposing `allUserEmails` - you can only
-- see your own, and having this behaviour can lead to bad practices from
-- frontend teams.
COMMENT ON TABLE app_public.user_emails IS E'@omit all\nInformation about a user''s email address.';

COMMENT ON COLUMN app_public.user_emails.email IS E'The users email address, in `a@b.c` format.';

COMMENT ON COLUMN app_public.user_emails.is_verified IS E'True if the user has is_verified their email address (by clicking the link in the email we sent them, or logging in with a social login provider), false otherwise.';

CREATE POLICY select_own ON app_public.user_emails
  FOR SELECT
    USING (user_id = app_public.current_user_id());

CREATE POLICY insert_own ON app_public.user_emails
  FOR INSERT
    WITH CHECK (
user_id = app_public.current_user_id());

CREATE POLICY delete_own ON app_public.user_emails
  FOR DELETE
    USING (user_id = app_public.current_user_id());

-- TODO check this isn't the last one!
GRANT SELECT ON app_public.user_emails TO graphiledemo_visitor;

GRANT INSERT (email) ON app_public.user_emails TO graphiledemo_visitor;

GRANT DELETE ON app_public.user_emails TO graphiledemo_visitor;

--------------------------------------------------------------------------------
CREATE TABLE app_private.user_email_secrets(
  user_email_id int PRIMARY KEY REFERENCES app_public.user_emails ON DELETE CASCADE,
  verification_token text,
  password_reset_email_sent_at timestamptz
);

ALTER TABLE app_private.user_email_secrets ENABLE ROW LEVEL SECURITY;

COMMENT ON TABLE app_private.user_email_secrets IS E'The contents of this table should never be visible to the user. Contains data mostly related to email verification and avoiding spamming users.';

COMMENT ON COLUMN app_private.user_email_secrets.password_reset_email_sent_at IS E'We store the time the last password reset was sent to this email to prevent the email getting flooded.';

CREATE FUNCTION app_private.tg_user_email_secrets__insert_with_user_email()
  RETURNS TRIGGER
  AS $$
DECLARE
  v_verification_token text;
BEGIN
  IF NEW.is_verified IS FALSE THEN
    v_verification_token = encode(gen_random_bytes(4), 'hex');
  END IF;
  INSERT INTO app_private.user_email_secrets(
    user_email_id,
    verification_token)
  VALUES (
    NEW.id,
    v_verification_token);
  RETURN NEW;
END;
$$
LANGUAGE plpgsql
VOLATILE SET search_path
FROM
  CURRENT;

CREATE TRIGGER _500_insert_secrets
  AFTER INSERT ON app_public.user_emails FOR EACH ROW
  EXECUTE PROCEDURE app_private.tg_user_email_secrets__insert_with_user_email();

COMMENT ON FUNCTION app_private.tg_user_email_secrets__insert_with_user_email() IS E'Ensures that every user_email record has an associated user_email_secret record.';

--------------------------------------------------------------------------------
CREATE TABLE app_public.user_authentications(
  id serial PRIMARY KEY,
  user_id int NOT NULL REFERENCES app_public.users ON DELETE CASCADE,
  service text NOT NULL,
  identifier text NOT NULL,
  details jsonb NOT NULL DEFAULT '{}' ::jsonb,
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now(),
  CONSTRAINT uniq_user_authentications UNIQUE (service, identifier)
);

ALTER TABLE app_public.user_authentications ENABLE ROW LEVEL SECURITY;

CREATE TRIGGER _100_timestamps
  BEFORE INSERT OR UPDATE ON app_public.user_authentications FOR EACH ROW
  EXECUTE PROCEDURE app_private.tg__update_timestamps();

COMMENT ON TABLE app_public.user_authentications IS E'@omit all\nContains information about the login providers this user has used, so that they may disconnect them should they wish.';

COMMENT ON COLUMN app_public.user_authentications.user_id IS E'@omit';

COMMENT ON COLUMN app_public.user_authentications.service IS E'The login service used, e.g. `twitter` or `github`.';

COMMENT ON COLUMN app_public.user_authentications.identifier IS E'A unique identifier for the user within the login service.';

COMMENT ON COLUMN app_public.user_authentications.details IS E'@omit\nAdditional profile details extracted from this login method';

CREATE POLICY select_own ON app_public.user_authentications
  FOR SELECT
    USING (user_id = app_public.current_user_id());

CREATE POLICY delete_own ON app_public.user_authentications
  FOR DELETE
    USING (user_id = app_public.current_user_id());

-- TODO check this isn't the last one, or that they have a verified email address
GRANT SELECT ON app_public.user_authentications TO graphiledemo_visitor;

GRANT DELETE ON app_public.user_authentications TO graphiledemo_visitor;

--------------------------------------------------------------------------------
CREATE TABLE app_private.user_authentication_secrets(
  user_authentication_id int NOT NULL PRIMARY KEY REFERENCES app_public.user_authentications ON DELETE CASCADE,
  details jsonb NOT NULL DEFAULT '{}' ::jsonb
);

ALTER TABLE app_private.user_authentication_secrets ENABLE ROW LEVEL SECURITY;

-- NOTE: user_authentication_secrets doesn't need an auto-inserter as we handle
-- that everywhere that can create a user_authentication row.
--------------------------------------------------------------------------------
CREATE FUNCTION app_public.forgot_password(email text)
  RETURNS boolean
  AS $$
DECLARE
  v_user_email app_public.user_emails;
  v_reset_token text;
  v_reset_min_duration_between_emails interval = interval '30 minutes';
  v_reset_max_duration interval = interval '3 days';
BEGIN
  -- Find the matching user_email
  SELECT
    user_emails.* INTO v_user_email
  FROM
    app_public.user_emails
  WHERE
    user_emails.email = forgot_password.email::citext
  ORDER BY
    is_verified DESC,
    id DESC;
  IF NOT (v_user_email IS NULL) THEN
    -- See if we've triggered a reset recently
    IF EXISTS (
      SELECT
        1
      FROM
        app_private.user_email_secrets
      WHERE
        user_email_id = v_user_email.id
        AND password_reset_email_sent_at IS NOT NULL
        AND password_reset_email_sent_at > now() - v_reset_min_duration_between_emails) THEN
    RETURN TRUE;
  END IF;
  -- Fetch or generate reset token
  UPDATE
    app_private.user_secrets
  SET
    reset_password_token =(
      CASE WHEN reset_password_token IS NULL
        OR reset_password_token_generated < NOW() - v_reset_max_duration THEN
        encode(gen_random_bytes(6), 'hex')
      ELSE
        reset_password_token
      END),
    reset_password_token_generated =(
      CASE WHEN reset_password_token IS NULL
        OR reset_password_token_generated < NOW() - v_reset_max_duration THEN
        now()
      ELSE
        reset_password_token_generated
      END)
  WHERE
    user_id = v_user_email.user_id
  RETURNING
    reset_password_token INTO v_reset_token;
  -- Don't allow spamming an email
  UPDATE
    app_private.user_email_secrets
  SET
    password_reset_email_sent_at = now()
  WHERE
    user_email_id = v_user_email.id;
  -- Trigger email send
  PERFORM
    app_jobs.add_job('user__forgot_password', json_build_object('id', v_user_email.user_id, 'email', v_user_email.email::text, 'token', v_reset_token));
  RETURN TRUE;
END IF;
  RETURN FALSE;
END;
$$
LANGUAGE plpgsql
STRICT
SECURITY DEFINER VOLATILE SET search_path
FROM
  CURRENT;

COMMENT ON FUNCTION app_public.forgot_password(email text) IS E'@resultFieldName success\nIf you''ve forgotten your password, give us one of your email addresses and we'' send you a reset token. Note this only works if you have added an email address!';

--------------------------------------------------------------------------------
CREATE FUNCTION app_private.login(username text, PASSWORD text)
  RETURNS app_public.users
  AS $$
DECLARE
  v_user app_public.users;
  v_user_secret app_private.user_secrets;
  v_login_attempt_window_duration interval = interval '6 hours';
BEGIN
  SELECT
    users.* INTO v_user
  FROM
    app_public.users
  WHERE
    -- Match username against users username, or any verified email address
(users.username = login.username
      OR EXISTS (
        SELECT
          1
        FROM
          app_public.user_emails
        WHERE
          user_id = users.id
          AND is_verified IS TRUE
          AND email = login.username::citext));
  IF NOT (v_user IS NULL) THEN
    -- Load their secrets
    SELECT
      * INTO v_user_secret
    FROM
      app_private.user_secrets
    WHERE
      user_secrets.user_id = v_user.id;
    -- Have there been too many login attempts?
    IF (v_user_secret.first_failed_password_attempt IS NOT NULL AND v_user_secret.first_failed_password_attempt > NOW() - v_login_attempt_window_duration AND v_user_secret.password_attempts >= 20) THEN
      RAISE EXCEPTION 'User account locked - too many login attempts'
        USING errcode = 'LOCKD';
      END IF;
      -- Not too many login attempts, let's check the password
      IF v_user_secret.password_hash = crypt(PASSWORD, v_user_secret.password_hash) THEN
        -- Excellent - they're loggged in! Let's reset the attempt tracking
        UPDATE
          app_private.user_secrets
        SET
          password_attempts = 0,
          first_failed_password_attempt = NULL
        WHERE
          user_id = v_user.id;
        RETURN v_user;
      ELSE
        -- Wrong password, bump all the attempt tracking figures
        UPDATE
          app_private.user_secrets
        SET
          password_attempts =(
            CASE WHEN first_failed_password_attempt IS NULL
              OR first_failed_password_attempt < now() - v_login_attempt_window_duration THEN
              1
            ELSE
              password_attempts + 1
            END),
          first_failed_password_attempt =(
            CASE WHEN first_failed_password_attempt IS NULL
              OR first_failed_password_attempt < now() - v_login_attempt_window_duration THEN
              now()
            ELSE
              first_failed_password_attempt
            END)
        WHERE
          user_id = v_user.id;
        RETURN NULL;
      END IF;
    ELSE
      -- No user with that email/username was found
      RETURN NULL;
    END IF;
END;
$$
LANGUAGE plpgsql
STRICT
SECURITY DEFINER VOLATILE SET search_path
FROM
  CURRENT;

COMMENT ON FUNCTION app_private.login(username text, PASSWORD text) IS E'Returns a user that matches the username/password combo, or null on failure.';

--------------------------------------------------------------------------------
CREATE FUNCTION app_public.reset_password(user_id int, reset_token text, new_password text)
  RETURNS app_public.users
  AS $$
DECLARE
  v_user app_public.users;
  v_user_secret app_private.user_secrets;
  v_reset_max_duration interval = interval '3 days';
BEGIN
  SELECT
    users.* INTO v_user
  FROM
    app_public.users
  WHERE
    id = user_id;
  IF NOT (v_user IS NULL) THEN
    -- Load their secrets
    SELECT
      * INTO v_user_secret
    FROM
      app_private.user_secrets
    WHERE
      user_secrets.user_id = v_user.id;
    -- Have there been too many reset attempts?
    IF (v_user_secret.first_failed_reset_password_attempt IS NOT NULL AND v_user_secret.first_failed_reset_password_attempt > NOW() - v_reset_max_duration AND v_user_secret.reset_password_attempts >= 20) THEN
      RAISE EXCEPTION 'Password reset locked - too many reset attempts'
        USING errcode = 'LOCKD';
      END IF;
      -- Not too many reset attempts, let's check the token
      IF v_user_secret.reset_password_token = reset_token THEN
        -- Excellent - they're legit; let's reset the password as requested
        UPDATE
          app_private.user_secrets
        SET
          password_hash = crypt(new_password, gen_salt('bf')),
          password_attempts = 0,
          first_failed_password_attempt = NULL,
          reset_password_token = NULL,
          reset_password_token_generated = NULL,
          reset_password_attempts = 0,
          first_failed_reset_password_attempt = NULL
        WHERE
          user_secrets.user_id = v_user.id;
        RETURN v_user;
      ELSE
        -- Wrong token, bump all the attempt tracking figures
        UPDATE
          app_private.user_secrets
        SET
          reset_password_attempts =(
            CASE WHEN first_failed_reset_password_attempt IS NULL
              OR first_failed_reset_password_attempt < now() - v_reset_max_duration THEN
              1
            ELSE
              reset_password_attempts + 1
            END),
          first_failed_reset_password_attempt =(
            CASE WHEN first_failed_reset_password_attempt IS NULL
              OR first_failed_reset_password_attempt < now() - v_reset_max_duration THEN
              now()
            ELSE
              first_failed_reset_password_attempt
            END)
        WHERE
          user_secrets.user_id = v_user.id;
        RETURN NULL;
      END IF;
    ELSE
      -- No user with that id was found
      RETURN NULL;
    END IF;
END;
$$
LANGUAGE plpgsql
STRICT VOLATILE
SECURITY DEFINER SET search_path
FROM
  CURRENT;

COMMENT ON FUNCTION app_public.reset_password(user_id int, reset_token text, new_password text) IS E'After triggering forgotPassword, you''ll be sent a reset token. Combine this with your user ID and a new password to reset your password.';

--------------------------------------------------------------------------------
CREATE FUNCTION app_private.really_create_user(username text, email text, email_is_verified bool, name text, avatar_url text, PASSWORD text DEFAULT NULL)
  RETURNS app_public.users
  AS $$
DECLARE
  v_user app_public.users;
  v_username text = username;
BEGIN
  -- Sanitise the username, and make it unique if necessary.
  IF v_username IS NULL THEN
    v_username = coalesce(name, 'user');
  END IF;
  v_username = regexp_replace(v_username, '^[^a-z]+', '', 'i');
  v_username = regexp_replace(v_username, '[^a-z0-9]+', '_', 'i');
  IF v_username IS NULL OR length(v_username) < 3 THEN
    v_username = 'user';
  END IF;
  SELECT
    (
      CASE WHEN i = 0 THEN
        v_username
      ELSE
        v_username || i::text
      END) INTO v_username
  FROM
    generate_series(0, 1000) i
WHERE
  NOT EXISTS (
    SELECT
      1
    FROM
      app_public.users
    WHERE
      users.username =(
        CASE WHEN i = 0 THEN
          v_username
        ELSE
          v_username || i::text
        END))
LIMIT 1;
  -- Insert the new user
  INSERT INTO app_public.users(
    username,
    name,
    avatar_url)
  VALUES (
    v_username,
    name,
    avatar_url)
RETURNING
  * INTO v_user;
  -- Add the user's email
  IF email IS NOT NULL THEN
    INSERT INTO app_public.user_emails(
      user_id,
      email,
      is_verified)
    VALUES (
      v_user.id,
      email,
      email_is_verified);
  END IF;
  -- Store the password
  IF PASSWORD IS NOT NULL THEN
    UPDATE
      app_private.user_secrets
    SET
      password_hash = crypt(PASSWORD, gen_salt('bf'))
    WHERE
      user_id = v_user.id;
  END IF;
  RETURN v_user;
END;
$$
LANGUAGE plpgsql
VOLATILE SET search_path
FROM
  CURRENT;

COMMENT ON FUNCTION app_private.really_create_user(username text, email text, email_is_verified bool, name text, avatar_url text, PASSWORD text) IS E'Creates a user account. All arguments are optional, it trusts the calling method to perform sanitisation.';

--------------------------------------------------------------------------------
CREATE FUNCTION app_private.register_user(f_service character varying, f_identifier character varying, f_profile json, f_auth_details json, f_email_is_verified boolean DEFAULT FALSE)
  RETURNS app_public.users
  AS $$
DECLARE
  v_user app_public.users;
  v_email citext;
  v_name text;
  v_username text;
  v_avatar_url text;
  v_user_authentication_id int;
BEGIN
  -- Extract data from the user’s OAuth profile data.
  v_email := f_profile ->> 'email';
  v_name := f_profile ->> 'name';
  v_username := f_profile ->> 'username';
  v_avatar_url := f_profile ->> 'avatar_url';
  -- Create the user account
  v_user = app_private.really_create_user(username => v_username, email => v_email, email_is_verified => f_email_is_verified, name => v_name, avatar_url => v_avatar_url);
  -- Insert the user’s private account data (e.g. OAuth tokens)
  INSERT INTO app_public.user_authentications(
    user_id,
    service,
    identifier,
    details)
  VALUES (
    v_user.id,
    f_service,
    f_identifier,
    f_profile)
RETURNING
  id INTO v_user_authentication_id;
  INSERT INTO app_private.user_authentication_secrets(
    user_authentication_id,
    details)
  VALUES (
    v_user_authentication_id,
    f_auth_details);
  RETURN v_user;
END;
$$
LANGUAGE plpgsql
VOLATILE
SECURITY DEFINER SET search_path
FROM
  CURRENT;

COMMENT ON FUNCTION app_private.register_user(f_service character varying, f_identifier character varying, f_profile json, f_auth_details json, f_email_is_verified boolean) IS E'Used to register a user from information gleaned from OAuth. Primarily used by link_or_register_user';

--------------------------------------------------------------------------------
CREATE FUNCTION app_private.link_or_register_user(f_user_id integer, f_service character varying, f_identifier character varying, f_profile json, f_auth_details json)
  RETURNS app_public.users
  AS $$
DECLARE
  v_matched_user_id int;
  v_matched_authentication_id int;
  v_email citext;
  v_name text;
  v_avatar_url text;
  v_user app_public.users;
  v_user_email app_public.user_emails;
BEGIN
  -- See if a user account already matches these details
  SELECT
    id,
    user_id INTO v_matched_authentication_id,
    v_matched_user_id
  FROM
    app_public.user_authentications
  WHERE
    service = f_service
    AND identifier = f_identifier
  LIMIT 1;
  IF v_matched_user_id IS NOT NULL AND f_user_id IS NOT NULL AND v_matched_user_id <> f_user_id THEN
    RAISE EXCEPTION 'A different user already has this account linked.'
      USING errcode = 'TAKEN';
    END IF;
    v_email = f_profile ->> 'email';
    v_name := f_profile ->> 'name';
    v_avatar_url := f_profile ->> 'avatar_url';
    IF v_matched_authentication_id IS NULL THEN
      IF f_user_id IS NOT NULL THEN
        -- Link new account to logged in user account
        INSERT INTO app_public.user_authentications(
          user_id,
          service,
          identifier,
          details)
        VALUES (
          f_user_id,
          f_service,
          f_identifier,
          f_profile)
      RETURNING
        id,
        user_id INTO v_matched_authentication_id,
        v_matched_user_id;
        INSERT INTO app_private.user_authentication_secrets(
          user_authentication_id,
          details)
        VALUES (
          v_matched_authentication_id,
          f_auth_details);
      ELSIF v_email IS NOT NULL THEN
        -- See if the email is registered
        SELECT
          * INTO v_user_email
        FROM
          app_public.user_emails
        WHERE
          email = v_email
          AND is_verified IS TRUE;
        IF NOT (v_user_email IS NULL) THEN
          -- User exists!
          INSERT INTO app_public.user_authentications(
            user_id,
            service,
            identifier,
            details)
          VALUES (
            v_user_email.user_id,
            f_service,
            f_identifier,
            f_profile)
        RETURNING
          id,
          user_id INTO v_matched_authentication_id,
          v_matched_user_id;
          INSERT INTO app_private.user_authentication_secrets(
            user_authentication_id,
            details)
          VALUES (
            v_matched_authentication_id,
            f_auth_details);
        END IF;
      END IF;
    END IF;
    IF v_matched_user_id IS NULL AND f_user_id IS NULL AND v_matched_authentication_id IS NULL THEN
      -- Create and return a new user account
      RETURN app_private.register_user(f_service, f_identifier, f_profile, f_auth_details, TRUE);
    ELSE
      IF v_matched_authentication_id IS NOT NULL THEN
        UPDATE
          app_public.user_authentications
        SET
          details = f_profile
        WHERE
          id = v_matched_authentication_id;
        UPDATE
          app_private.user_authentication_secrets
        SET
          details = f_auth_details
        WHERE
          user_authentication_id = v_matched_authentication_id;
        UPDATE
          app_public.users
        SET
          name = coalesce(users.name, v_name),
          avatar_url = coalesce(users.avatar_url, v_avatar_url)
        WHERE
          id = v_matched_user_id
        RETURNING
          * INTO v_user;
        RETURN v_user;
      ELSE
        -- v_matched_authentication_id is null
        -- -> v_matched_user_id is null (they're paired)
        -- -> f_user_id is not null (because the if clause above)
        -- -> v_matched_authentication_id is not null (because of the separate if block above creating a user_authentications)
        -- -> contradiction.
        RAISE EXCEPTION 'This should not occur';
      END IF;
    END IF;
END;
$$
LANGUAGE plpgsql
VOLATILE
SECURITY DEFINER SET search_path
FROM
  CURRENT;

COMMENT ON FUNCTION app_private.link_or_register_user(f_user_id integer, f_service character varying, f_identifier character varying, f_profile json, f_auth_details json) IS E'If you''re logged in, this will link an additional OAuth login to your account if necessary. If you''re logged out it may find if an account already exists (based on OAuth details or email address) and return that, or create a new user account if necessary.';

