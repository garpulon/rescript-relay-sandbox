# Dev vs Prod

## Dev
Once built locally, container images are run via docker-compose. The containers are configured for
development and will live reload simple code changes. Dev containers must be rebuilt on changes to 
node_modules, I believe.

## Prod
Once built, container images are pushed to gcr.io. The appropriate google cloud service runs the container.

# File Structure
```
./
├── package.json         # scripts to build and run containers
├── docker-compose.yml   # configuration for running containers (dev & prod locally)
├── build-containers.sh  # build commands for dev and prod containers
├── containers
│   ├── graphile-worker  # runs connected to db instance, executes async js
│   ├── postgraphile     # runs on demand, connected to pg, serves gql
```

# How they are built
The container images are built with [Cloud Native Buildpacks](https://buildpacks.io), specifically the
[paketo](https://paketo.io) kind. 

What makes buildpacks nice for this application is
- buildpacks lock down the containers you are running
- buildpacks roll out security fixes
- buildpacks built OCI compliant images (good for automated cloud security audit)
- buildpacks let you define an app in terms of `npm run start`, so we end up declaratively building our containers rather than configuring them manually

Notes about the CNB process:
- It is meant to build the containers in a reproducible manner
- Pack can be integrated with CI:CD tools
- The containers seem to be pretty large, but presumably are running on a common base


## Shell Dependencies

### Required
3. [Docker](https://www.docker.com/): run container images
4. [Docker Compose](https://docs.docker.com/compose/): orchestrate containers locally
5. [pack](https://buildpacks.io/docs/tools/pack/): run buildpacks

### Recommended
1. [gcloud CLI](https://cloud.google.com/sdk/gcloud/)
2. [cloud-sql-proxy](https://github.com/GoogleCloudPlatform/cloud-sql-proxy)
3. [nvm](https://github.com/nvm-sh/nvm): the project requires you to be using a specific node version

## Logging into google artifact registry

```sh
gcloud auth login
gcloud config set project rescript-relay-sandbox
gcloud auth configure-docker us-east4-docker.pkg.dev
```


## $PROJECT_ROOT/.env
Add a ```.env``` file to the project root with the following variables:

```sh

GRAPHILE_PORT=5000
PGHOST=host.docker.internal
PGPORT=5432
PGDATABASE
PGUSER
PGPASSWORD
GRAPHILE_SCHEMA
GRAPHILE_JWT_TOKEN_IDENTIFIER
GRAPHILE_JWT_TOKEN_SECRET
GRAPHILE_DEFAULT_ROLE

POSTGRAPHILE_IMAGE_NAME
GRAPHILE_WORKER_IMAGE_NAME

SENDGRID_API_KEY
```

## Building & Running



## Cloud SQL Proxy
If you wish to proxy your connection to the production DB locally, you can use cloud-sql-proxy
In one terminal, run the ```cloud-sql-proxy```:
```sh
cloud_sql_proxy --port $PORT "rescript-relay-sandbox:us-central1:rescript-relay-sandbox-db"
```

### Running the Cloud SQL Proxy
```sh
cloud_sql_proxy --port $PORT "rescript-relay-sandbox:us-central1:rescript-relay-sandbox-db"
```




# Further Notes:

## Kompose
https://kompose.io will translate docker-compose files into kubernetes deployment files
