# gcloud scratch notes

1. [gcloud CLI](https://cloud.google.com/sdk/gcloud/)
2. [cloud-sql-proxy](https://github.com/GoogleCloudPlatform/cloud-sql-proxy)

```sh
gcloud auth login
```

project rescript-relay-sandbox

```sh
gcloud config set project rescript-relay-sandbox
```

```sh
cloud_sql_proxy --port 5431 "rescript-relay-sandbox:us-central1:rescript-relay-sandbox-db"
```
