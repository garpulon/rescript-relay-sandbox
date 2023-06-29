-- Forum example
CREATE TABLE app_public.forums(
  id serial PRIMARY KEY,
  slug text NOT NULL CHECK (length(slug) < 30 AND slug ~ '^([a-z0-9]-?)+$') UNIQUE,
  name text NOT NULL CHECK (length(name) > 0),
  description text NOT NULL DEFAULT '',
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now()
);

ALTER TABLE app_public.forums ENABLE ROW LEVEL SECURITY;

CREATE TRIGGER _100_timestamps
  BEFORE INSERT OR UPDATE ON app_public.forums
  FOR EACH ROW
  EXECUTE PROCEDURE app_private.tg__update_timestamps();

COMMENT ON TABLE app_public.forums IS E'A subject-based grouping of topics and posts.';

COMMENT ON COLUMN app_public.forums.slug IS E'An URL-safe alias for the `Forum`.';

COMMENT ON COLUMN app_public.forums.name IS E'The name of the `Forum` (indicates its subject matter).';

COMMENT ON COLUMN app_public.forums.description IS E'A brief description of the `Forum` including it''s purpose.';

CREATE POLICY select_all ON app_public.forums
  FOR SELECT
    USING (TRUE);

CREATE POLICY insert_admin ON app_public.forums
  FOR INSERT
    WITH CHECK (
app_public.current_user_is_admin());

CREATE POLICY update_admin ON app_public.forums
  FOR UPDATE
    USING (app_public.current_user_is_admin());

CREATE POLICY delete_admin ON app_public.forums
  FOR DELETE
    USING (app_public.current_user_is_admin());

GRANT SELECT ON app_public.forums TO graphiledemo_visitor;

GRANT INSERT (slug, name, description) ON app_public.forums TO graphiledemo_visitor;

GRANT UPDATE (slug, name, description) ON app_public.forums TO graphiledemo_visitor;

GRANT DELETE ON app_public.forums TO graphiledemo_visitor;

--------------------------------------------------------------------------------
CREATE TABLE app_public.topics(
  id serial PRIMARY KEY,
  forum_id int NOT NULL REFERENCES app_public.forums ON DELETE CASCADE,
  author_id citext NOT NULL DEFAULT app_public.current_user_id() REFERENCES basic_auth.users ON DELETE CASCADE,
  title text NOT NULL CHECK (length(title) > 0),
  body text NOT NULL DEFAULT '',
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now()
);

ALTER TABLE app_public.topics ENABLE ROW LEVEL SECURITY;

CREATE TRIGGER _100_timestamps
  BEFORE INSERT OR UPDATE ON app_public.topics
  FOR EACH ROW
  EXECUTE PROCEDURE app_private.tg__update_timestamps();

COMMENT ON TABLE app_public.topics IS E'@foreignKey (author_id) references app_public.users(email)|@fieldName author\n@omit all\nAn individual message thread within a Forum.';

COMMENT ON COLUMN app_public.topics.title IS E'The title of the `Topic`.';

COMMENT ON COLUMN app_public.topics.body IS E'The body of the `Topic`, which Posts reply to.';

CREATE POLICY select_all ON app_public.topics
  FOR SELECT
    USING (TRUE);

CREATE POLICY insert_admin ON app_public.topics
  FOR INSERT
    WITH CHECK (
author_id = app_public.current_user_id());

CREATE POLICY update_admin ON app_public.topics
  FOR UPDATE
    USING (author_id = app_public.current_user_id()
      OR app_public.current_user_is_admin());

CREATE POLICY delete_admin ON app_public.topics
  FOR DELETE
    USING (author_id = app_public.current_user_id()
      OR app_public.current_user_is_admin());

GRANT SELECT ON app_public.topics TO graphiledemo_visitor;

GRANT INSERT (forum_id, title, body) ON app_public.topics TO graphiledemo_visitor;

GRANT UPDATE (title, body) ON app_public.topics TO graphiledemo_visitor;

GRANT DELETE ON app_public.topics TO graphiledemo_visitor;

CREATE FUNCTION app_public.topics_body_summary(t app_public.topics, max_length int = 30)
  RETURNS text
  LANGUAGE sql
  STABLE
  SET search_path
FROM
  current
  AS $$
  SELECT
    CASE WHEN length(t.body) > max_length THEN
    LEFT(t.body,
      max_length - 3) || '...'
  ELSE
    t.body
    END;
$$;

--------------------------------------------------------------------------------
CREATE TABLE app_public.posts(
  id serial PRIMARY KEY,
  topic_id int NOT NULL REFERENCES app_public.topics ON DELETE CASCADE,
  author_id citext NOT NULL DEFAULT app_public.current_user_id() REFERENCES basic_auth.users ON DELETE CASCADE,
  body text NOT NULL DEFAULT '',
  created_at timestamptz NOT NULL DEFAULT now(),
  updated_at timestamptz NOT NULL DEFAULT now()
);

ALTER TABLE app_public.posts ENABLE ROW LEVEL SECURITY;

CREATE TRIGGER _100_timestamps
  BEFORE INSERT OR UPDATE ON app_public.posts
  FOR EACH ROW
  EXECUTE PROCEDURE app_private.tg__update_timestamps();

COMMENT ON TABLE app_public.posts IS E'@foreignKey (author_id) references app_public.users(email)|@fieldName author\n@omit all\nAn individual message thread within a Forum.';

COMMENT ON COLUMN app_public.posts.id IS E'@omit create,update';

COMMENT ON COLUMN app_public.posts.topic_id IS E'@omit update';

COMMENT ON COLUMN app_public.posts.author_id IS E'@omit create,update';

COMMENT ON COLUMN app_public.posts.body IS E'The body of the `Topic`, which Posts reply to.';

COMMENT ON COLUMN app_public.posts.created_at IS E'@omit create,update';

COMMENT ON COLUMN app_public.posts.updated_at IS E'@omit create,update';

CREATE POLICY select_all ON app_public.posts
  FOR SELECT
    USING (TRUE);

CREATE POLICY insert_admin ON app_public.posts
  FOR INSERT
    WITH CHECK (
author_id = app_public.current_user_id());

CREATE POLICY update_admin ON app_public.posts
  FOR UPDATE
    USING (author_id = app_public.current_user_id()
      OR app_public.current_user_is_admin());

CREATE POLICY delete_admin ON app_public.posts
  FOR DELETE
    USING (author_id = app_public.current_user_id()
      OR app_public.current_user_is_admin());

GRANT SELECT ON app_public.posts TO graphiledemo_visitor;

GRANT INSERT (topic_id, body) ON app_public.posts TO graphiledemo_visitor;

GRANT UPDATE (body) ON app_public.posts TO graphiledemo_visitor;

GRANT DELETE ON app_public.posts TO graphiledemo_visitor;

CREATE FUNCTION app_public.random_number()
  RETURNS int
  LANGUAGE sql
  STABLE
  AS $$
  SELECT
    4;
$$;

COMMENT ON FUNCTION app_public.random_number() IS 'Chosen by fair dice roll. Guaranteed to be random. XKCD#221';

CREATE FUNCTION app_public.forums_about_cats()
  RETURNS SETOF app_public.forums
  LANGUAGE sql
  STABLE
  AS $$
  SELECT
    *
  FROM
    app_public.forums
  WHERE
    slug LIKE 'cat-%';
$$;

