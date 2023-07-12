#!/bin/bash

set -euo pipefail
# Note that postgraphile will take either DATABASE_URL if present
# OR will use PGHOST PGDATABASE PGUSER PGPASSWORD and, optionally, PGPORT


FORENV=$(echo ${NODE_ENV:-"production"} | tr '[:upper:]' '[:lower:]')
GRAPHILE_PORT="${PORT:-"5000"}"

if [ "$FORENV" =  "development" ]
then
  echo "  ==================   running with DEVELOPMENT settings   ==================  "
  # this is development
  EXTENDED_ERROR_PARAMS="hint,detail,errcode"
  GRAPHIQL_FLAG="--graphiql / --enhance-graphiql"
  QUERY_FLAG="--allow-explain"
  SHOW_ERROR_STACK_FLAG="--show-error-stack=json"
  EXPORT_SCHEMA_FLAG="--export-schema-graphql schema.graphql"
  CORS_FLAG="--cors"
  WATCH_FLAG="--watch"
else 
  echo "  ==================   running with PRODUCTION settings   ==================  "
  EXTENDED_ERROR_PARAMS="errcode"
  GRAPHIQL_FLAG="--disable-graphiql"
  QUERY_FLAG="--disable-query-log"
  SHOW_ERROR_STACK_FLAG=""
  EXPORT_SCHEMA_FLAG=""
  CORS_FLAG=""
  WATCH_FLAG=""
fi



CMD=$(echo postgraphile \
  --plugins @graphile/operation-hooks \
  --operation-messages \
  --append-plugins @graphile-contrib/pg-simplify-inflector \
  -n 0.0.0.0 \
  --port $GRAPHILE_PORT \
  --jwt-token-identifier "$GRAPHILE_JWT_TOKEN_IDENTIFIER" \
  --jwt-secret "$GRAPHILE_JWT_TOKEN_SECRET" \
  --default-role "$GRAPHILE_DEFAULT_ROLE" \
  --classic-ids \
  --subscriptions \
  --dynamic-json \
  --no-setof-functions-contain-nulls \
  --no-ignore-rbac \
  $WATCH_FLAG \
  $CORS_FLAG \
  $SHOW_ERROR_STACK_FLAG \
  --extended-errors "$EXTENDED_ERROR_PARAMS" \
  $EXPORT_SCHEMA_FLAG \
  $GRAPHIQL_FLAG \
  $QUERY_FLAG \
  --enable-query-batching \
  --legacy-relations omit \
  --schema $GRAPHILE_SCHEMA)

if [ "$FORENV" =  "development" ]
then
  echo $CMD;
fi

$CMD