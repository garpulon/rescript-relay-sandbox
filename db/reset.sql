-- First, we clean out the old stuff
DROP SCHEMA IF EXISTS app_public CASCADE;

DROP SCHEMA IF EXISTS app_hidden CASCADE;

DROP SCHEMA IF EXISTS app_private CASCADE;

DROP SCHEMA IF EXISTS app_jobs CASCADE;

DROP SCHEMA IF EXISTS basic_auth CASCADE;

--------------------------------------------------------------------------------
-- Definitions <500 are common to all sorts of applications,
-- they solve common concerns such as storing user data,
-- logging people in, triggering password reset emails,
-- mitigating brute force attacks and more.
-- Background worker tasks
\ir 100_jobs.sql
-- app_public, app_private and base permissions
\ir 200_schemas.sql
-- Useful utility functions
\ir 300_utils.sql
-- Users, authentication, emails, etc
--\ir 400_users.sql
-- Users, authentication, emails, etc
\ir 401_users_new.sql
--------------------------------------------------------------------------------
-- Definitions >=500 are application specific, defining the tables
-- in your application, and dealing with concerns such as a welcome
-- email or customising the user tables to your whim
-- Forum tables
\ir 700_forum.sql
\ir 999_data.sql
--------------------------------------------------------------------------------
-- Emailer function
\ir 1000_emailer.sql
