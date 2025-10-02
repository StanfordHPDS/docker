#!/bin/bash
# Script to build and push all Python images in the correct order

set -e

# Get the directory of this script
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
DOCKER_DIR="$(dirname "$SCRIPT_DIR")"

# Platform targets
PLATFORMS="linux/amd64,linux/arm64"

# Build python-uv-core first (base for all Python images)
echo "Building stanfordhpds/python-uv-core..."
docker buildx build --platform "$PLATFORMS" --push \
    -t stanfordhpds/python-uv-core:latest "$DOCKER_DIR/python/uv-core"

# Build python-uv (with ONBUILD)
echo "Building stanfordhpds/python-uv..."
docker buildx build --platform "$PLATFORMS" --push \
    -t stanfordhpds/python-uv:latest "$DOCKER_DIR/python/uv"

# Build python-uv-ssh
echo "Building stanfordhpds/python-uv-ssh..."
docker buildx build --platform "$PLATFORMS" --push \
    -t stanfordhpds/python-uv-ssh:latest "$DOCKER_DIR/python/uv-ssh"

# Build python-uv-rstudio
echo "Building stanfordhpds/python-uv-rstudio..."
docker buildx build --platform "$PLATFORMS" --push \
    -t stanfordhpds/python-uv-rstudio:latest "$DOCKER_DIR/python/uv-rstudio"

echo "All Python images built and pushed successfully!"