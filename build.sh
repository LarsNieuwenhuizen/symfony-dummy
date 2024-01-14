#!/usr/bin/env bash
set -eux;

tag="latest";

#sed -i 's/${VERSION}/'${tag}'/' DistributionPackages/LarsNieuwenhuizen.Fotografie.Website/Resources/Private/Templates/FusionObjects/LicenseHeader.html
export DOCKER_BUILDKIT=1

docker buildx build --no-cache --platform linux/amd64,linux/arm64 --target=fpm -t larsnieuwenhuizen/technight-php:latest --push .
docker buildx build --no-cache --platform linux/amd64,linux/arm64 --target=webserver -t larsnieuwenhuizen/technight-webserver:latest --push .
