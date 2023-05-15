#!/bin/bash

postgraphile \
  -n 0.0.0.0 \
  --jwt-token-identifier app_public.jwt_token \
  --jwt-secret asecretfortesting \
  --default-role drew \
  --cors \
  --classic-ids \
  --subscriptions \
  --watch \
  --dynamic-json \
  --no-setof-functions-contain-nulls \
  --no-ignore-rbac \
  --show-error-stack=json \
  --extended-errors hint,detail,errcode \
  --append-plugins @graphile-contrib/pg-simplify-inflector \
  --export-schema-graphql schema.graphql \
  --graphiql "/" \
  --enhance-graphiql \
  --allow-explain \
  --enable-query-batching \
  --legacy-relations omit \
  --schema app_public \
  --connection $DATABASE_URL
