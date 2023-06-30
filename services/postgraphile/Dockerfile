FROM node:alpine
LABEL description="Instant high-performance GraphQL API for your PostgreSQL database https://github.com/graphile/postgraphile"

# Install PostGraphile and PostGraphile connection filter plugin
RUN yarn global add postgraphile
RUN yarn add @graphile-contrib/pg-simplify-inflector @graphile/operation-hooks

RUN apk update && apk upgrade && apk add bash

EXPOSE 5000

COPY postgraphile-entrypoint.sh /usr/local/bin
RUN chmod +x /usr/local/bin/postgraphile-entrypoint.sh

ENTRYPOINT ["postgraphile-entrypoint.sh"]
