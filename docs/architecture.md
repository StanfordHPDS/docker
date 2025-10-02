# Docker Repository Organization Plan for stanfordhpds

## Overview

This repository will serve as a centralized location for all Stanford HPDS Docker images. The images are designed to support reproducible scientific computing workflows with both Python and R environments.

## Repository Structure

```
docker/
├── README.md                          # Main repository documentation
├── .github/
│   └── workflows/
│       ├── build-base.yml             # CI/CD for base image
│       ├── build-python.yml           # CI/CD for Python images
│       ├── build-r.yml                # CI/CD for R images
│       └── build-extensions.yml       # CI/CD for extension images
├── base/
│   ├── Dockerfile                     # stanfordhpds/base (current file)
│   ├── README.md                      # Base image documentation
│   └── scripts/                       # Helper scripts for base image
├── python/
│   ├── uv/
│   │   ├── Dockerfile                 # stanfordhpds/python-uv
│   │   └── README.md
│   ├── uv-ssh/
│   │   ├── Dockerfile                 # stanfordhpds/python-uv-ssh
│   │   ├── sshd_config                # SSH daemon configuration
│   │   └── README.md
│   └── uv-rstudio/
│       ├── Dockerfile                 # stanfordhpds/python-uv-rstudio
│       ├── rstudio-prefs.json         # RStudio preferences
│       └── README.md
├── r/
│   ├── renv/
│   │   ├── Dockerfile                 # stanfordhpds/r-renv
│   │   └── README.md
│   ├── renv-ssh/
│   │   ├── Dockerfile                 # stanfordhpds/r-renv-ssh
│   │   ├── sshd_config
│   │   └── README.md
│   └── renv-rstudio/
│       ├── Dockerfile                 # stanfordhpds/r-renv-rstudio
│       ├── rstudio-prefs.json
│       └── README.md
├── examples/
│   ├── python-uv-make/                # Example Python project with Make
│   │   ├── Dockerfile
│   │   ├── Makefile
│   │   ├── pyproject.toml
│   │   ├── uv.lock
│   │   ├── src/
│   │   │   └── pipeline.py
│   │   ├── tests/
│   │   └── README.md
│   └── r-renv-targets/                # Example R project with targets
│       ├── Dockerfile
│       ├── _targets.R
│       ├── renv.lock
│       ├── R/
│       │   └── functions.R
│       ├── data/
│       └── README.md
├── scripts/
│   ├── build-all.sh                   # Build all images
│   ├── test-images.sh                 # Test all images
│   └── push-images.sh                 # Push to Docker Hub
├── docs/
│   ├── architecture.md                # Architecture decisions
│   ├── contributing.md                # Contribution guidelines
│   ├── migration-guide.md             # Migration from other setups
│   └── usage-guide.md                 # How to use the images
└── docker-compose.yml                 # Example compose file

```

## Image Architecture

### Base Image (stanfordhpds/base)
- Ubuntu 24.04 LTS base
- Common system libraries for scientific computing
- uv for Python package management
- rig for R version management
- Quarto for literate programming
- Git and GitHub CLI
- TinyTeX for LaTeX support

### Python Images
1. **stanfordhpds/python-uv**
   - Extends base image
   - Python 3.12 (default, configurable)
   - uv configured for optimal performance
   - Common scientific Python tools

2. **stanfordhpds/python-uv-ssh**
   - Extends python-uv
   - OpenSSH server for remote development
   - Configured for Positron IDE
   - Security hardened

3. **stanfordhpds/python-uv-rstudio**
   - Extends python-uv
   - RStudio Server Open Source
   - Jupyter kernel integration
   - Web-based IDE access

### R Images
1. **stanfordhpds/r-renv**
   - Extends base image
   - R 4.4.x (managed by rig)
   - renv for package management
   - System dependencies pre-installed

2. **stanfordhpds/r-renv-ssh**
   - Extends r-renv
   - OpenSSH server configuration
   - Remote R session support

3. **stanfordhpds/r-renv-rstudio**
   - Extends r-renv
   - RStudio Server Open Source
   - Pre-configured for reproducibility

## Key Features

### Reproducibility
- All versions pinned (OS, languages, packages)
- Multi-architecture support (amd64/arm64)
- Dependency lock files (uv.lock, renv.lock)
- Immutable base images with semantic versioning

### Performance
- Multi-stage builds for minimal image size
- Strategic layer caching
- uv for 10-100x faster Python package installation
- Pre-compiled system dependencies

### Security
- Non-root user by default
- Minimal attack surface
- Regular security updates
- SSH images use key-based authentication only

### Developer Experience
- Quick startup times
- Pre-configured development environments
- IDE integration (RStudio, Positron)
- Comprehensive documentation

## Docker Hub Organization

Images will be published to Docker Hub under the `stanfordhpds` organization:

- `stanfordhpds/base:latest`
- `stanfordhpds/base:1.0.0`
- `stanfordhpds/python-uv:latest`
- `stanfordhpds/python-uv:3.12`
- `stanfordhpds/python-uv-ssh:latest`
- `stanfordhpds/python-uv-rstudio:latest`
- `stanfordhpds/r-renv:latest`
- `stanfordhpds/r-renv:4.4`
- `stanfordhpds/r-renv-ssh:latest`
- `stanfordhpds/r-renv-rstudio:latest`

## Versioning Strategy

1. **Base Image**: Semantic versioning (e.g., 1.0.0)
2. **Language Images**: Language version tags (e.g., python-uv:3.12, r-renv:4.4)
3. **Latest Tags**: Always point to the most recent stable version
4. **Date Tags**: Optional YYYY-MM-DD tags for specific builds

## CI/CD Pipeline

### GitHub Actions Workflows
1. **Automated Builds**
   - Triggered on push to main
   - Builds all changed images
   - Multi-architecture builds

2. **Testing**
   - Image build verification
   - Container startup tests
   - Example project validation

3. **Security Scanning**
   - Vulnerability scanning with Trivy
   - SBOM generation
   - License compliance

4. **Publishing**
   - Automatic push to Docker Hub
   - Tag management
   - Release notes generation

## Usage Examples

### Python Development
```bash
# Basic Python development
docker run -it --rm -v $(pwd):/workspace stanfordhpds/python-uv:latest

# SSH access for Positron
docker run -d -p 2222:22 -v $(pwd):/workspace stanfordhpds/python-uv-ssh:latest

# RStudio access
docker run -d -p 8787:8787 -v $(pwd):/workspace stanfordhpds/python-uv-rstudio:latest
```

### R Development
```bash
# Basic R development
docker run -it --rm -v $(pwd):/workspace stanfordhpds/r-renv:latest

# RStudio Server
docker run -d -p 8787:8787 -e PASSWORD=yourpassword stanfordhpds/r-renv-rstudio:latest
```

## Maintenance Plan

1. **Weekly**: Security updates check
2. **Monthly**: Dependency updates (uv, renv, system packages)
3. **Quarterly**: Major version updates evaluation
4. **Annually**: Ubuntu LTS version migration planning

## Contributing

See [CONTRIBUTING.md](contributing.md) for guidelines on:
- Adding new images
- Updating existing images
- Testing procedures
- Pull request process