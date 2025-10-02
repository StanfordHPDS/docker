#!/bin/bash
# Script to build and push all R images in the correct order

set -e

# Get the directory of this script
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
DOCKER_DIR="$(dirname "$SCRIPT_DIR")"

# Platform targets
PLATFORMS="linux/amd64,linux/arm64"

# Build r-renv-core first (base for all R images)
echo "Building stanfordhpds/r-renv-core..."
docker buildx build --platform "$PLATFORMS" --push \
    -t stanfordhpds/r-renv-core:latest "$DOCKER_DIR/r/renv-core"

# Build r-renv (with ONBUILD)
echo "Building stanfordhpds/r-renv..."
docker buildx build --platform "$PLATFORMS" --push \
    -t stanfordhpds/r-renv:latest "$DOCKER_DIR/r/renv"

# Build r-renv-ssh
echo "Building stanfordhpds/r-renv-ssh..."
docker buildx build --platform "$PLATFORMS" --push \
    -t stanfordhpds/r-renv-ssh:latest "$DOCKER_DIR/r/renv-ssh"

# Build r-renv-rstudio
echo "Building stanfordhpds/r-renv-rstudio..."
docker buildx build --platform "$PLATFORMS" --push \
    -t stanfordhpds/r-renv-rstudio:latest "$DOCKER_DIR/r/renv-rstudio"

echo "All R images built and pushed successfully!"