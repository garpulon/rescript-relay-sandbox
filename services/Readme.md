# Dev vs Prod

Services are defined in compose for now. We translate them into kubernetes services.

Until multiple instances of containers need to be load balanced, this should be fine.

At such a time as load balancing, cloud functions, and other functionality is needed, a more in depth kubernetes integration would be necessary.

## Dependencies

1. [gcloud CLI](https://cloud.google.com/sdk/gcloud/)
2. [cloud-sql-proxy](https://github.com/GoogleCloudPlatform/cloud-sql-proxy)
3. [Docker](https://www.docker.com/)
4. [Docker Compose](https://docs.docker.com/compose/)
5. [Terraform](https://www.terraform.io/)

## To login

```sh
gcloud auth login
gcloud config set project rescript-relay-sandbox
gcloud auth configure-docker us-east4-docker.pkg.dev
```

## Running the Cloud SQL Proxy
```sh
cloud_sql_proxy --port 5431 "rescript-relay-sandbox:us-central1:rescript-relay-sandbox-db"
```

## Local Development
Add a ```.env``` file to the ```services``` directory with the following variables:

```sh
PORT
PGHOST
PGPORT
PGDATABASE
PGUSER
PGPASSWORD
GRAPHILE_SCHEMA
GRAPHILE_JWT_TOKEN_IDENTIFIER
GRAPHILE_JWT_TOKEN_SECRET
GRAPHILE_DEFAULT_ROLE
POSTGRAPHILE_IMAGE_NAME
```

Symlink ```services/.env``` file to ```services/images/.env```:

```sh
cd services/images
ln -s ./../.env ./
```

In one terminal, run the ```clous-sql-proxy```:
```sh
cloud_sql_proxy --port 5431 "rescript-relay-sandbox:us-central1:rescript-relay-sandbox-db"
```

_Note: choose the appropriate port based on your ```.env``` file!_

Within ```services```, build and run:

```sh
docker-compose build
docker-compose up
```

# Further Notes:

## Kompose
https://kompose.io will translate docker-compose files into kubernetes deployment files

## 2 layers of compose files
services: *run* services that are defined as images
services/images: *build* images that define services

## 2 layers of env files
see the docker compose files in services and define any image name variables in services/images/docker-compose.yml

RECOMMENDATION: mash these two together and list everything in services/.env

    cd services/images
    ln -s ./../.env ./

services/.env: secrets for local service container runtimes
services/images/.env: secrets for local container build and push