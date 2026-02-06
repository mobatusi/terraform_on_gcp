#!/bin/bash

# Build and Push Docker Image to Docker Hub
# Usage: ./build-and-push.sh YOUR_DOCKERHUB_USERNAME

set -e

if [ -z "$1" ]; then
    echo "Error: Docker Hub username is required"
    echo "Usage: ./build-and-push.sh YOUR_DOCKERHUB_USERNAME"
    exit 1
fi

DOCKERHUB_USERNAME=$1
IMAGE_NAME="terraform-gcp-app"
TAG="latest"
FULL_IMAGE_NAME="${DOCKERHUB_USERNAME}/${IMAGE_NAME}:${TAG}"

echo "Building Docker image..."
docker build -t ${IMAGE_NAME}:${TAG} .

echo "Tagging image for Docker Hub..."
docker tag ${IMAGE_NAME}:${TAG} ${FULL_IMAGE_NAME}

echo "Logging in to Docker Hub..."
docker login

echo "Pushing image to Docker Hub..."
docker push ${FULL_IMAGE_NAME}

echo "Successfully pushed ${FULL_IMAGE_NAME} to Docker Hub!"
