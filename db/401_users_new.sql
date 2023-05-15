
-- keep this all separate
-- inspired by https://postgrest.org/en/stable/how-tos/sql-user-management.html#sql-user-management

CREATE SCHEMA IF NOT EXISTS basic_auth;
create extension if not exists pgcrypto;
create extension if not exists pgjwt;


-------------------------------------------------------------------------------





-- First we’ll need a table to keep track of our users:

create table if not exists
basic_auth.users (
  email    citext primary key check ( email ~* '^.+@.+\..+$' ),
  pass     text not null check (length(pass) < 512),
  role     name not null check (length(role) < 512)
);

-- We would like the role to be a foreign key to actual database roles, however PostgreSQL does not support these constraints against the pg_roles table. We’ll use a trigger to manually enforce it.

create or replace function
basic_auth.check_role_exists() returns trigger as $$
begin
  if not exists (select 1 from pg_roles as r where r.rolname = new.role) then
    raise foreign_key_violation using message =
      'unknown database role: ' || new.role;
    return null;
  end if;
  return new;
end
$$ language plpgsql;

drop trigger if exists ensure_user_role_exists on basic_auth.users;
create constraint trigger ensure_user_role_exists
  after insert or update on basic_auth.users
  for each row
  execute procedure basic_auth.check_role_exists();

-- Next we’ll use the pgcrypto extension and a trigger to keep passwords safe in the users table.

create or replace function
basic_auth.encrypt_pass() returns trigger as $$
begin
  if tg_op = 'INSERT' or new.pass <> old.pass then
    new.pass = crypt(new.pass, gen_salt('bf'));
  end if;
  return new;
end
$$ language plpgsql;

drop trigger if exists encrypt_pass on basic_auth.users;
create trigger encrypt_pass
  before insert or update on basic_auth.users
  for each row
  execute procedure basic_auth.encrypt_pass();

-- With the table in place we can make a helper to check a password against the encrypted column. It returns the database role for a user if the email and password are correct.

create or replace function
basic_auth.user_role(email text, pass text) returns name
  language plpgsql
  as $$
begin
  return (
  select role from basic_auth.users
   where users.email = user_role.email
     and users.pass = crypt(user_role.pass, users.pass)
  );
end;
$$;

-------------------------------------------------------------------------------------

-- add type
CREATE TYPE app_public.jwt_token AS (
    role text,
    email text,
    exp integer
);

-- this should not be in a file
-- ALTER DATABASE relaysandbox SET "basic_auth.jwt_secret" TO 'asecretfortesting';

-- login should be on your exposed schema

create or replace function
app_public.login(email text, pass text) returns app_public.jwt_token as $$
declare
  _role name;
  result app_public.jwt_token;
begin
  -- check email and password
  select basic_auth.user_role(email, pass) into _role;
  if _role is null then
    raise invalid_password using message = 'invalid user or password';
  end if;
  
  select _role, login.email, extract(epoch from now())::integer + 60*60
    into result;
  return result;
end;
$$ language plpgsql security definer;

grant execute on function app_public.login(text,text) to anon;


