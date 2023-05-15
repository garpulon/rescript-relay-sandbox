create function app_public.current_user_id() returns text as $$
  select nullif(current_setting('jwt.claims.email', true), '')::text;
$$ language sql stable set search_path from current;
comment on function  app_public.current_user_id() is
  E'@omit\nHandy method to get the current user ID for use in RLS policies, etc; in GraphQL, use `currentUser{id}` instead.';


------------------------------------------------

-- keep this all separate
-- inspired by https://postgrest.org/en/stable/how-tos/sql-user-management.html#sql-user-management

CREATE SCHEMA IF NOT EXISTS basic_auth;
create extension if not exists pgcrypto;


-------------------------------------------------------------------------------





-- First we’ll need a table to keep track of our users:

create table if not exists
basic_auth.users (
  email    citext primary key check ( email ~* '^.+@.+\..+$' ),
  pass     text not null check (length(pass) < 512),
  role     name not null check (length(role) < 512),
  is_admin  bool not null default false
);

-- this view could use some love 
create or replace view app_public.users as select email, is_admin, 'https://placekitten.com/100/100' as avatar_url from basic_auth.users;

comment on column app_public.users.email is 
  E'@notNull';
comment on column app_public.users.is_admin is
  E'@notNull';


create function app_public.current_user() returns app_public.users as $$
  select users.* from app_public.users where email = app_public.current_user_id();
$$ language sql stable set search_path from current;


create function app_public.current_user_is_admin() returns bool as $$
  -- We're using exists here because it guarantees true/false rather than true/false/null
  select exists(
    select 1 from basic_auth.users where email = app_public.current_user_id() and is_admin = true
	);
$$ language sql stable set search_path from current security definer;



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
   where users.email = trim(user_role.email)
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


create or replace function app_private.raise_client_message(_level text, _paths text[], _msg text) returns void as $$
 begin
      raise notice '%', _msg
      using errcode = 'OPMSG',
      detail = json_build_object(
          'level', _level,
          'path', _paths
      )::text
 return;
 end;
 $$ language plpgsql security definer;

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
    perform app_private.raise_client_message('warn', '{"email", "pass"}', 'invalid user name or password');
    select null into result;
    return result;
  end if;
  
  select _role, login.email, extract(epoch from now())::integer + 60*60
    into result;
  return result;
end;
$$ language plpgsql security definer;

-- login should be on your exposed schema
create or replace function
app_public.register(email text, pass text) returns bool as $$
declare
  extantEmail text;
begin
  -- check email and password
  select t.email from basic_auth.users t where t.email=trim(register.email)
    into extantEmail;

  if extantEmail is not null then 
    perform app_private.raise_client_message('warn', '{"email"}', 'cannot create an account with this email address');
    return false;
  end if;

  if length(pass) < 8 then 
    perform app_private.raise_client_message('warn', '{"password"}', 'password must be at least 8 chars in length');
    return false;
  end if;

  insert into basic_auth.users values (email, pass, 'loggedin');
  return true;
end;
$$ language plpgsql security definer;


