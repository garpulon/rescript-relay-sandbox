CREATE SCHEMA app_public;

CREATE SCHEMA app_private;

GRANT usage ON SCHEMA app_public TO graphiledemo_visitor;

-- This allows inserts without granting permission to the serial primary key column.
ALTER DEFAULT privileges FOR ROLE graphiledemo IN SCHEMA app_public GRANT usage,
SELECT
    ON sequences TO graphiledemo_visitor;

