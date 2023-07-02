# Gcloud Deps

1. [gcloud CLI](https://cloud.google.com/sdk/gcloud/)
2. [cloud-sql-proxy](https://github.com/GoogleCloudPlatform/cloud-sql-proxy)

## To login
```sh
gcloud auth login
gcloud config set project rescript-relay-sandbox
```

## Running the Cloud SQL Proxy
```sh
cloud_sql_proxy --port 5431 "rescript-relay-sandbox:us-central1:rescript-relay-sandbox-db"
```

# Other Deployment Deps

1. [Docker](https://www.docker.com/)
2. [Docker Compose](https://docs.docker.com/compose/)
3. [Terraform](https://www.terraform.io/)

```sh
cd services
touch .env
...
```
