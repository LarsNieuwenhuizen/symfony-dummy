#!/usr/bin/env bash
set -eux;

if [ $# -eq 1 ]; then
    tag=$1;
else
  tag="latest";
fi

export DOCKER_BUILDKIT=1

docker buildx build --no-cache --platform linux/amd64,linux/arm64 --target=fpm -t larsnieuwenhuizen/technight-php:${tag} --push .
docker buildx build --no-cache --platform linux/amd64,linux/arm64 --target=webserver -t larsnieuwenhuizen/technight-webserver:${tag} --push .
