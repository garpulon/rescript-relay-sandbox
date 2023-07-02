# Dev vs Prod
Services are defined in compose for now. We translate them into kubernetes services. 

Until multiple instances of containers need to be load balanced, this should be fine. 

At such a time as load balancing, cloud functions, and other functionality is needed, a more in depth kubernetes integration would be necessary. 

# Kompose
https://kompose.io will translate docker-compose files into kubernetes deployment files

# 2 layers of compose files
services: *run* services that are defined as images
services/images: *build* images that define services

# 2 layers of env files
see the docker compose files in services and define any image name variables in services/images/docker-compose.yml

RECOMMENDATION: mash these two together and list everything in services/.env

    cd services/images
    ln -s ./../.env ./

services/.env: secrets for local service container runtimes
services/images/.env: secrets for local container build and push

