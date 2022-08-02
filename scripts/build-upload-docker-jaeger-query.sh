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
    --push \
    cmd/query

docker tag $ECR_REGISTRY/$PROJECT_NAME:$COMMIT_HASH $ECR_REGISTRY/$PROJECT_NAME:$COMMIT_HASH
docker tag $ECR_REGISTRY/$PROJECT_NAME:$COMMIT_HASH $ECR_REGISTRY/$PROJECT_NAME:latest

docker push $ECR_REGISTRY/$PROJECT_NAME:$COMMIT_HASH
docker push $ECR_REGISTRY/$PROJECT_NAME:latest
