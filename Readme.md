# Rescript Relay Sandbox

This repo is a port of the Forum software and schema from 
https://github.com/graphile/examples

## Stack
- Postgres >=14 (datastore/backend functions)
- Postgraphile CLI (introspect a postgres schema and serve a graphql API)
- React + Relay (more facebook tech)
- Rescript (compile to javascript type inferred FP language (also technically more facebook tech))
- Rescript-relay (adds a layer to the relay compiler that emits types, a ppx to the preprocesses your source, and a vscode plugin to support this)

## Prerequisites
- A recent (and running) postgres instance, likely on localhost, 
which postgraphile can connect to using a connection string
- VSCode (w/ plugins for rescript, rescript-relay, etc for vscode)
- Plugins for rescript, rescript-relay, etc for vscode
- Yarn 


## Getting it running

in psql (or pgcli):
    create database relayforums;

in bash: 
    # assuming you start in the root project dir
    cd ./db;
    psql relayforums < ./reset.sql
    # return to project root
    cd ../
    yarn;
    mkdir ./src/__generated__;
    yarn relay:build;
    yarn re:build;

    touch .env
    # put in your db urls...
    echo "DATABASE_URL=postgres://drew:1234@localhost/relayforums" >> .env;

    # now see if postgraphile is serving graphql
    # it will tell you a url when it starts up
    # once you can see graphiql, you're in business
    # you'll want to keep this running
    yarn postgraphile:dev

    # should give you a different url that will host your
    # project as you develop
    yarn parcel:serve;
