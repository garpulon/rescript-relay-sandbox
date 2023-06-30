-- creation of authenticator roles
REASSIGN owned BY anon TO drew;

DROP owned BY anon;

DROP ROLE IF EXISTS anon;

REASSIGN owned BY loggedin TO drew;

DROP owned BY loggedin;

DROP ROLE IF EXISTS loggedin;

CREATE ROLE anon noinherit;

CREATE ROLE loggedin noinherit;

GRANT usage ON SCHEMA app_public TO anon, loggedin;

--grant execute on function app_public.login to
GRANT ALL ON ALL tables IN SCHEMA app_public TO anon;

GRANT EXECUTE ON ALL functions IN SCHEMA app_public TO anon;

GRANT ALL ON ALL tables IN SCHEMA app_public TO loggedin;

GRANT ALL ON ALL sequences IN SCHEMA app_public TO loggedin;

INSERT INTO basic_auth.users
VALUES (
  'drew@jococruise.com',
  '1234',
  'loggedin',
  TRUE);

-------------------------
SELECT
  app_public.register('bill@jococruise.com', '12341234');

SELECT
  app_public.register('jill@jococruise.com', '12341234');

SELECT
  app_public.register('ramesh@jococruise.com', '12341234');

SELECT
  app_public.register('sinead@jococruise.com', '12341234');

SELECT
  app_public.register('blibbo@jococruise.com', '12341234');

INSERT INTO app_public.forums(
  slug,
  name,
  description)
VALUES (
  'testimonials',
  'Testimonials',
  'How do you rate PostGraphile?'),
(
  'feedback',
  'Feedback',
  'How are you finding PostGraphile?'),
(
  'cat-life',
  'Cat Life',
  'A forum all about cats and how fluffy they are and how they completely ignore their owners unless there is food. Or yarn.'),
(
  'cat-help',
  'Cat Help',
  'A forum to seek advice if your cat is becoming troublesome.');

INSERT INTO app_public.topics(
  forum_id,
  author_id,
  title,
  body)
VALUES (
  1,
  'jill@jococruise.com',
  'Thank you!',
  '500-1500 requests per second on a single server is pretty awesome.'),
(
  1,
  'sinead@jococruise.com',
  'PostGraphile is powerful',
  'PostGraphile is a powerful, idomatic, and elegant tool.'),
(
  1,
  'blibbo@jococruise.com',
  'Recently launched',
  'At this point, it’s quite hard for me to come back and enjoy working with REST.'),
(
  3,
  'bill@jococruise.com',
  'I love cats!',
  'They''re the best!');

INSERT INTO app_public.posts(
  topic_id,
  author_id,
  body)
VALUES (
  1,
  'bill@jococruise.com',
  'I''m super pleased with the performance - thanks!'),
(
  2,
  'bill@jococruise.com',
  'Thanks so much!'),
(
  3,
  'bill@jococruise.com',
  'Tell me about it - GraphQL is awesome!'),
(
  4,
  'bill@jococruise.com',
  'Dont you just love cats? Cats cats cats cats cats cats cats cats cats cats cats cats Cats cats cats cats cats cats cats cats cats cats cats cats'),
(
  4,
  'jill@jococruise.com',
  'Yeah cats are really fluffy I enjoy squising their fur they are so goregous and fluffy and squishy and fluffy and gorgeous and squishy and goregous and fluffy and squishy and fluffy and gorgeous and squishy'),
(
  4,
  'ramesh@jococruise.com',
  'I love it when they completely ignore you until they want something. So much better than dogs am I rite?');

