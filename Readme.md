# Rescript Relay Sandbox

This repo is a port of the Forum software and schema from
https://github.com/graphile/examples

## Stack

Our stack consists of the following technologies:

- [PostgreSQL](https://www.postgresql.org/) >=14: Used as our datastore and for
  backend functions
- [Postgraphile CLI](https://www.graphile.org/): Used to introspect a Postgres
  schema and serve a GraphQL API
- [React](https://react.dev/) + [Relay](https://relay.dev/): Frontend libraries
  for building user interfaces and managing API data (developed by Facebook)
- [Rescript](https://rescript-lang.org/): A type-inferred functional programming
  language that commpiles to JavaScript (again, Facebook tech)
- [rescript-relay](https://github.com/zth/rescript-relay): An addition to the
  Relay compiler that emits types, adds a preprocessor (ppx) to your source, and
  supports a VSCode plugin.

## Prerequisites

Before you begin, ensure you have the following set up:

- [Node.js](https://nodejs.org/en) >=18.6: Used as a runtime environment for
  executing JavaScript
- PostgreSQL >=14: A recent and running instance, likely on `localhost`, which
  Postgraphile can connect to using a connection string.
- [VSCode](https://code.visualstudio.com/): For coding and utilizing plugins for
  Rescript, rescript-relay, and Relay.
- [Yarn](https://yarnpkg.com/): To manage package dependencies
- [Watchman](https://facebook.github.io/watchman/): A file watching service
  developed by Facebook, which is necessary for Relay.
- Environment Variables: `DATABASE_URL` for Postgres connection.

In case any of these tools are not installed, here are some quick setup guides:

### For MacOS:

First, if you haven't already, install [Homebrew](https://brew.sh/), a package
manager for MacOS that makes it easy to install software from the command line.

1. **Node.js**: Download and install from
   [Node.js's website](https://nodejs.org/en/download).
2. **PostgreSQL**: Install with `brew install postgresql@15`.
3. **VSCode**: Download and install from
   [VSCode's website](https://code.visualstudio.com/download).
4. **Yarn**: Install with `brew install yarn`.
5. **Watchman**: Install with `brew install watchman`.

### For Windows:

1. **Node.js**: Download and install from
   [Node.js's website](https://nodejs.org/en/download).
2. **PostgreSQL**: Download and install from
   [PostgreSQL's website](https://www.postgresql.org/download/windows/).
3. **VSCode**: Download and install from
   [VSCode's website](https://code.visualstudio.com/download).
4. **Yarn**: Download and install from
   [Yarn's website](https://yarnpkg.com/).
5. **Watchman**: Download and install from
   [Watchman's website](https://facebook.github.io/watchman/docs/install/#buildinstall).

Additionally, you will want to install the following VSCode extensions:

- [Rescript](https://marketplace.visualstudio.com/items?itemName=chenglou92.rescript-vscode)
- [Relay](https://marketplace.visualstudio.com/items?itemName=meta.relay)
- [GraphQL](https://marketplace.visualstudio.com/items?itemName=GraphQL.vscode-graphql)
- [rescript-relay](https://marketplace.visualstudio.com/items?itemName=GabrielNordeborn.vscode-rescript-relay)

## Setting up the project

After cloning this repository and installing the prerequisites, you can start
setting up the project:

1. **Create a PostgreSQL Database.** Use `pgsql` or `pgcli` to run the following command:

   ```sql
   CREATE DATABASE relayforums;
   ```

   _Note_: The below connection string assumes a Postgres user named `drew` with
   password `1234`. If you would like to use a different user, you will need to
   modify the connection string in the `.env` file and update the
   `999_data.sql` file in the `db` directory. Either way, ensure that the user
   has proper privileges on the `relayforums` database:

   ```sql
   CREATE USER drew WITH PASSWORD '1234';
   ALTER USER drew WITH SUPERUSER;
   ```

2. **Run bash commands.**. Assuming you start in the root project directory,
   navigate to the `db` directory, populate the database, return to the root
   directory, install dependencies, and build the project:

   ```bash
   cd ./db;
   psql relayforums < ./reset.sql # or psql -f ./reset.sql -d relayforums
   cd ../
   yarn;
   mkdir ./src/__generated__;
   yarn relay:build;
   yarn re:build;
   ```

3. **Create a `.env` file.**. In the root directory, create a file called `.env`
   and add the database connection string:

   ```bash
   touch .env;
   echo "DATABASE_URL=postgres://drew:1234@localhost/relayforums" >> .env;
   ```

4. **Start the Postgraphile server.**. In the root directory, run the following.
   Wait until the server starts up and you can see GraphiQL at the URL it
   provides:

   ```bash
    yarn postgraphile:dev
   ```

   Keep this server up and running in a terminal. Then, in a separate
   terminal...

5. **Start the Parcel server.** In the root directory, run the following
   command to serve your project as you develop:

   ```bash
   yarn parcel:serve;
   ```

   This will start a server at `localhost:1234` that will automatically reload
   when you make changes to your code.

And that's it! You should now be able to see the Forum app running at
`localhost:1234` and the GraphiQL interface at `localhost:5000/graphiql`.
