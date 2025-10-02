# Stanford HPDS Docker Images

A collection of Docker images optimized for reproducible data science workflows with R and Python.

## Quick Start

### Python with uv
```bash
# Run a Python project with uv
docker run -it --rm -v $(pwd):/workspace stanfordhpds/python-uv:latest

# With SSH access (for Positron IDE)
docker run -d -p 2222:22 -v ~/.ssh/id_rsa.pub:/root/.ssh/authorized_keys:ro stanfordhpds/python-uv-ssh:latest

# With RStudio Server
docker run -d -p 8787:8787 -e PASSWORD=yourpassword stanfordhpds/python-uv-rstudio:latest
```

### R with renv
```bash
# Run an R project with renv
docker run -it --rm -v $(pwd):/project stanfordhpds/r-renv:latest

# With SSH access
docker run -d -p 2222:22 -v ~/.ssh/id_rsa.pub:/root/.ssh/authorized_keys:ro stanfordhpds/r-renv-ssh:latest

# With RStudio Server
docker run -d -p 8787:8787 -e PASSWORD=yourpassword stanfordhpds/r-renv-rstudio:latest
```

### Custom Development Environments
```bash
# Base image with SSH for custom setups
docker run -d -p 2222:22 -v ~/.ssh/id_rsa.pub:/root/.ssh/authorized_keys:ro stanfordhpds/base-ssh:latest

# Base image with RStudio for custom setups
docker run -d -p 8787:8787 -v $(pwd):/workspace stanfordhpds/base-rstudio:latest
```

## Available Images

| Image | Description | Key Features |
|-------|-------------|--------------|
| `stanfordhpds/base` | Base image with common tools | Ubuntu 24.04, uv, rig, Quarto, Git |
| `stanfordhpds/base-ssh` | Base + SSH server | For custom remote development setups |
| `stanfordhpds/base-rstudio` | Base + RStudio Server | For custom web-based RStudio development |
| `stanfordhpds/python-uv` | Python development with uv | Automated UV support |
| `stanfordhpds/python-uv-ssh` | Python + SSH server | Remote development with SSH + automated uv support |
| `stanfordhpds/python-uv-rstudio` | Python + RStudio Server | Web-based RStudio with Python support + automated uv support |
| `stanfordhpds/r-renv` | R development with renv | Automated renv support |
| `stanfordhpds/r-renv-ssh` | R + SSH server | Remote SSH development + automated renv support |
| `stanfordhpds/r-renv-rstudio` | R + RStudio Server | Web-based RStudio + automated renv support |

## Examples

See the [`examples/`](examples/) directory for complete project examples:
- [Python pipeline with uv and Make](examples/python-uv-make/)
- [R pipeline with renv and targets](examples/r-renv-targets/)

## Building Images Locally

All images are built for multiple architectures (linux/amd64, linux/arm64) using Docker Buildx.

**Prerequisites:**
- Docker with buildx support
- Logged in to Docker Hub (`docker login`) with push access

```bash
# Build and push all images (multi-architecture)
./scripts/build-all.sh

# Build and push specific image groups
./scripts/build-python-images.sh
./scripts/build-r-images.sh
```

**Note:** Images are automatically pushed to Docker Hub during the build process (required by buildx for multi-platform builds).
