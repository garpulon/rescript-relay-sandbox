#!/bin/bash

if [[ ! -z "${INSTANCE_UNIX_SOCKET}" ]]; then
  export PGHOST=$INSTANCE_UNIX_SOCKET
fi

if [ ! "$PGHOST" ]
then
  export PGHOST=$DB_HOST
fi

export PGPORT=$DB_PORT
export PGDATABASE=$DB_NAME
export PGUSER=$DB_USER
export PGPASSWORD=$DB_PASS
env

set -euo pipefail

exec postgraphile \
  --plugins @graphile/operation-hooks \
  --operation-messages \
  --append-plugins @graphile-contrib/pg-simplify-inflector \
  -n 0.0.0.0 \
  --port $PORT \
  --jwt-token-identifier $GRAPHILE_JWT_TOKEN_IDENTIFIER \
  --jwt-secret $GRAPHILE_JWT_TOKEN_SECRET \
  --default-role $GRAPHILE_DEFAULT_ROLE \
  --cors \
  --classic-ids \
  --subscriptions \
  --watch \
  --dynamic-json \
  --no-setof-functions-contain-nulls \
  --no-ignore-rbac \
  --show-error-stack=json \
  --extended-errors hint,detail,errcode \
  --export-schema-graphql schema.graphql \
  --graphiql "/" \
  --enhance-graphiql \
  --allow-explain \
  --enable-query-batching \
  --legacy-relations omit \
  --schema $GRAPHILE_SCHEMA \
  "$@"
