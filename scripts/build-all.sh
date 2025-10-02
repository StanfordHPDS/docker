#!/bin/bash
# Build and push all Docker images for multiple architectures

set -e

# Get the directory of this script
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
DOCKER_DIR="$(dirname "$SCRIPT_DIR")"

# Platform targets
PLATFORMS="linux/amd64,linux/arm64"

echo "Building and pushing all Stanford HPDS Docker images..."
echo "Platforms: $PLATFORMS"
echo "==========================================================="
echo "Note: You must be logged in to Docker Hub with push access"
echo ""

# Ensure buildx builder exists and supports multi-platform
echo "Setting up buildx builder..."
if ! docker buildx inspect multiplatform >/dev/null 2>&1; then
    docker buildx create --name multiplatform --driver docker-container --bootstrap
fi
docker buildx use multiplatform

# Build base image
echo "Building base image..."
docker buildx build --platform "$PLATFORMS" --push \
    -t stanfordhpds/base:latest "$DOCKER_DIR/base/"

# Build base variants (ssh, rstudio)
echo -e "\nBuilding base-ssh image..."
docker buildx build --platform "$PLATFORMS" --push \
    -t stanfordhpds/base-ssh:latest "$DOCKER_DIR/base/ssh/"

echo -e "\nBuilding base-rstudio image..."
docker buildx build --platform "$PLATFORMS" --push \
    -t stanfordhpds/base-rstudio:latest "$DOCKER_DIR/base/rstudio/"

# Build all Python images (core, uv, ssh, rstudio)
echo -e "\nBuilding Python images..."
"$SCRIPT_DIR/build-python-images.sh"

# Build all R images (core, renv, ssh, rstudio)
echo -e "\nBuilding R images..."
"$SCRIPT_DIR/build-r-images.sh"

echo -e "\n==========================================================="
echo "All images built and pushed successfully!"