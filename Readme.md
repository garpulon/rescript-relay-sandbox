# Enable yarn
Assumes Node.js >=18.6

    corepack enable
    corepack prepare yarn@stable --activate
    yarn init -2
    # needed for rescript to understand your files
    yarn config set nodeLinker node-modules

# Install rescript
https://rescript-lang.org/docs/manual/latest/installation

    yarn add rescript

    # get template bsconfig.json
    wget -O ./bsconfig.json https://raw.githubusercontent.com/rescript-lang/rescript-project-template/master/bsconfig.json
    
    # create a folder for source
    mkdir ./src
    
    # add to root bsconfig.json dictionary
    "bsc-flags": [
        "-open Belt"
    ],

    # add build scripts to package.sjon
    "scripts": {
        "re:build": "rescript build",
        "re:watch": "rescript build -w"
    }


# Install rescript react
https://rescript-lang.org/docs/react/latest/installation

    yarn add react@18 react-dom@18
    yarn add @rescript/react

    # add to bsconfig.json
    "jsx": { "version": 4, "mode": "automatic" },

    # update bs-dependencies 
    "bs-dependencies": ["@rescript/react"]

You'll note that when we install packages that are used and compiled by rescript, we must also update bs-dependencies. It's well named, because you think it would be able to infer the dependencies it should try to build from, e.g., package.json. Rescript has gone through a variety of names for a variety of overarching and subsidiary projects within what is now rescript. The compiler used to be called bucklescript, and that is the origin of the 'bs'.

# Add parcel and setup files for hello world
    yarn add --dev parcel

    touch ./src/index.html
    touch ./src/index.res
    touch ./src/App.res

    # add parcel watch script to package.json scripts dict
    "parcel:serve": "parcel serve --host localhost ./src/*.html"

    

# ./src/index.html
https://parceljs.org/getting-started/webapp/

    <!doctype html>
    <html lang="en">

    <head>
        <meta charset="utf-8" />
        <title>My First Parcel App</title>
        <script type="module" src="index.bs.js"></script>
    </head>

    <body>
        <h1>Hello, World!</h1>
    </body>

    </html>

# ./src/index.res
https://rescript-lang.org/docs/react/latest/rendering-elements

    // Dom access can actually fail. ReScript
    // is really explicit about handling edge cases!
    switch ReactDOM.querySelector("body") {
    | Some(rootElement) => {
        let root = ReactDOM.Client.createRoot(rootElement)
        ReactDOM.Client.Root.render(root, <App />)
    }
    | None => ()
    }

# ./src/App.res
    @react.component
    let make = () => {
    <div>
            {React.string("Hello ReScripters!")}
    </div>
    }


# parcel hello world

    # rescript compiler watching (keep open)
    yarn re:watch
    # parcel server (keep open)
    yarn parcel:serve

once both these commands are running and it builds, you'll
be able to load the hello world page in your browser at the
url provided in the parcel window


# postgres... 
yes, you will need a running postgres instance on your 
machine. i can't tell you how to install postgres on your 
machine because everyone needs to install postgres
by following their own heart. what i mean by this, of course, is that i already have it installed and i used homebrew and i'm not going to be uninstalling it.

THEN, make a database for this project

    postgres=# create database relaysandbox with owner $OWNER;

### add some tables and schemas
we're going to import the stuff from here, pretty much wholesale. i'll be doing this from my downloads folder. I just downloaded the thing as a zip.
https://github.com/graphile/examples/tree/master/db

    # your path may vary
    cd ~/Downloads/examples-master/db

    echo "create role graphiledemo_visitor" | psql relaysandbox
    echo "create role graphiledemo" | psql relaysandbox
    echo "CREATE EXTENSION IF NOT EXISTS citext WITH SCHEMA public" | psql relaysandbox

    psql relaysandbox < 100_jobs.sql
    psql relaysandbox < 200_schemas.sql
    psql relaysandbox < 300_utils.sql
    psql relaysandbox < 400_users.sql
    psql relaysandbox < 400_users.sql
    psql relaysandbox < 700_forum.sql
    psql relaysandbox < 999_data.sql


# postgraphile install
    yarn add postgraphile @graphile-contrib/pg-simplify-inflector
    # we'll be filling this out using contents of the link below this code block*
    touch ./postgraphile-dev.sh
    chmod +x ./postgraphile-dev.sh

**contents for shell script are invocation* from [here](https://www.graphile.org/postgraphile/usage-cli/#for-development)

add a command to run the dev instance to your package.json scripts

    "postgraphile:dev": "DATABASE_URL=postgres://user:password@localhost/relaysandbox ./postgraphile-dev.sh",

start it up (and keep it open)

    yarn postgraphile:dev

visit the link for graphiql to see what you've got for starters... http://localhost:5000/


# Install & Configure Relay
Install [relay rescript vscode extension](https://marketplace.visualstudio.com/items?itemName=GabrielNordeborn.vscode-rescript-relay)


https://rescript-relay-documentation.vercel.app/docs/getting-started

    # Add rescript-relay and dependencies to the project
    # We currently depend on Relay version 14, so install that exact version
    yarn add rescript-relay relay-runtime@14.1.0 react-relay@14.1.0

    # add ppx flags to bsconfig.json
    "ppx-flags": ["rescript-relay/ppx"],

    # update bsconfig dependences to include "rescript-relay"
    "bs-dependencies": ["@rescript/react", "rescript-relay"],

    # add (don't replace existing) relay scripts to package.json
    "scripts": {
        "relay:build": "rescript-relay-compiler",
        "relay:watch": "rescript-relay-compiler --watch"
    }

### Configure relay & Relay env
Add a relay.config.js to your project root with some 
default stuff in it, from [here](https://rescript-relay-documentation.vercel.app/docs/getting-started#configuring-relay)

    touch ./src/RelayEnv.res

Then add bs-fetch to bs-dependencies in your bsconfig.json:

    "bs-dependencies": ["bs-fetch"]

Copy paste code for environment per [this page](https://rescript-relay-documentation.vercel.app/docs/getting-started#setting-up-the-relay-environment)

Add a rescript port of fetch (...) so the above code compiles

    yarn add bs-fetch


