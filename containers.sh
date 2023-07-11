#!/bin/bash

set -euo pipefail

VERB=$1
IMG=$2
ENV=$3

USAGE="usage: containers.sh build|push IMG_NAME NODE_ENV"
IMG_SUFFIX=""
IMG_DIR_PATH=./containers
BUILD_ENV_VARS=""

case $VERB in 
  build | push)
    ;;

  *)
    echo "provide a recognized verb"
    echo $USAGE
    exit 1
    ;;
esac

case $ENV in 
  development | dev)
    NODE_ENV="development"
    IMG_SUFFIX="-dev"
    BUILD_ENV_VARS="--env BP_LIVE_RELOAD_ENABLED=true"
    ;;

  production | prod)
    NODE_ENV="production"
    BUILD_ENV_VARS=""
    ;;

  *)
    echo "provide a recognized NODE_ENV"
    echo $USAGE
    exit 2
    ;;
esac


build() {
    BUILD_DIR=$1
    IMG_NAME=$2

    # make sure they all get this one
    BUILD_ENV_VARS+=" --env NODE_ENV=$NODE_ENV"
    CMD=$(echo pack build "$IMG_NAME" \
      --path "$BUILD_DIR" \
      --builder paketobuildpacks/builder:base \
      --buildpack paketo-buildpacks/nodejs \
      $BUILD_ENV_VARS)

    echo $CMD
    $CMD
}

push() {
  IMG_NAME=$1
  CMD=$(echo docker push "$IMG_NAME")

  echo $CMD
  $CMD
}

# neat trick from https://unix.stackexchange.com/a/15217
case "$IMG:$VERB" in
  postgraphile:build)
      build $IMG_DIR_PATH/postgraphile "$POSTGRAPHILE_IMAGE_NAME$IMG_SUFFIX"
    ;;
  postgraphile:push)
      push "$POSTGRAPHILE_IMAGE_NAME$IMG_SUFFIX:latest"
    ;;
  graphile-worker:build)
      build $IMG_DIR_PATH/graphile-worker "$GRAPHILE_WORKER_IMAGE_NAME$IMG_SUFFIX"
    ;;
  graphile-worker:push)
      push "$GRAPHILE_WORKER_IMAGE_NAME$IMG_SUFFIX:latest"
    ;;

  *)
    echo "[$VERB:$IMG] not implemented provide a recognized image to build or fix me!"
    echo $USAGE
    exit 3
    ;;
esac
