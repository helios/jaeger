#!/bin/bash

set -euxf -o pipefail

make create-baseimg-debugimg
make build-binaries-linux

docker buildx build \
    --target release \
    --build-arg base_image=localhost:5000/baseimg_alpine:latest \
    --build-arg debug_image=localhost:5000/debugimg_alpine:latest \
    --platform=linux/amd64 \
    --file cmd/query/Dockerfile \
    --tag $ECR_REGISTRY/$PROJECT_NAME:$COMMIT_HASH \
    --tag $ECR_REGISTRY/$PROJECT_NAME:latest \
    --push \
    cmd/query
