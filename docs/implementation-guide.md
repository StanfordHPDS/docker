# Stanford HPDS Docker Images - Implementation Guide

This guide provides step-by-step instructions for implementing the Docker repository structure outlined in the repository plan.

## Prerequisites

Before starting:
1. Create the `stanfordhpds` organization on Docker Hub
2. Set up GitHub repository with appropriate access
3. Configure GitHub repository secrets:
   - `DOCKERHUB_TOKEN`: Docker Hub access token
   - Set repository variable `DOCKERHUB_USERNAME`

## Phase 1: Repository Setup (Day 1-2)

### 1.1 Create Repository Structure

```bash
# Create all directories
mkdir -p base python/{uv,uv-ssh,uv-rstudio} r/{renv,renv-ssh,renv-rstudio}
mkdir -p templates examples/{python-uv-make,r-renv-targets} 
mkdir -p scripts docs .github/workflows

# Move existing Dockerfile to base/
mv Dockerfile base/
```

### 1.2 Set Up Templates

Copy the template Dockerfiles from `scratch/dockerfile-templates/`:
- `ssh-template.Dockerfile` → `templates/`
- `rstudio-template.Dockerfile` → `templates/`

### 1.3 Configure GitHub Actions

Copy workflows from `scratch/github-actions/`:
- `build-base.yml` → `.github/workflows/`
- `build-python.yml` → `.github/workflows/`
- `build-r.yml` → `.github/workflows/`

### 1.4 Create Initial Documentation

Create README.md files:
- Root README.md with overview and quick start
- base/README.md with base image details
- Each subdirectory gets its own README.md

## Phase 2: Base Image Enhancement (Day 3-4)

### 2.1 Update Base Dockerfile

The current base Dockerfile is already well-structured. Consider:
- Add health check: `HEALTHCHECK CMD uv --version && rig --version`
- Add labels for metadata
- Document all installed tools

### 2.2 Test and Push Base Image

```bash
# Build locally
docker build -t stanfordhpds/base:latest base/

# Test
docker run --rm stanfordhpds/base:latest uv --version
docker run --rm stanfordhpds/base:latest rig --version

# Push (after GitHub Actions are set up)
git push origin main
```

## Phase 3: Python Images (Day 5-7)

### 3.1 Create Python uv Dockerfile

Copy from templates:
```bash
cp scratch/dockerfile-templates/python-uv.Dockerfile python/uv/Dockerfile
```

### 3.2 Build Extension Images

Use the build scripts:
```bash
cd templates
./build-ssh-images.sh
./build-rstudio-images.sh
```

### 3.3 Test Python Images

```bash
# Test basic Python image
docker run -it --rm -v $(pwd):/workspace stanfordhpds/python-uv:latest

# Test SSH access
docker run -d -p 2222:22 -v ~/.ssh/id_rsa.pub:/root/.ssh/authorized_keys:ro stanfordhpds/python-uv-ssh:latest
ssh -p 2222 root@localhost

# Test RStudio
docker run -d -p 8787:8787 -e PASSWORD=test123 stanfordhpds/python-uv-rstudio:latest
# Open http://localhost:8787
```

## Phase 4: R Images (Day 8-10)

### 4.1 Create R renv Dockerfile

Copy from templates:
```bash
cp scratch/dockerfile-templates/r-renv.Dockerfile r/renv/Dockerfile
```

### 4.2 Build R Extension Images

Use the same build scripts for SSH and RStudio variants.

### 4.3 Test R Images

```bash
# Test basic R image
docker run -it --rm -v $(pwd):/project stanfordhpds/r-renv:latest

# Test with an renv project
cd examples/r-renv-targets
docker build -t test-r-project .
docker run --rm test-r-project
```

## Phase 5: Examples and Testing (Day 11-12)

### 5.1 Copy Example Projects

Copy the examples from scratch:
```bash
cp -r scratch/examples/* examples/
```

### 5.2 Test Example Projects

```bash
# Python example
cd examples/python-uv-make
docker build -t test-python .
docker run --rm -v $(pwd)/outputs:/workspace/outputs test-python

# R example
cd examples/r-renv-targets
docker build -t test-r .
docker run --rm -v $(pwd)/outputs:/project/outputs test-r
```

## Phase 6: Documentation and Release (Day 13-14)

### 6.1 Complete Documentation

Create comprehensive docs:
- `docs/architecture.md`: Explain design decisions
- `docs/usage-guide.md`: How to use each image
- `docs/contributing.md`: How to contribute

### 6.2 Create Build Scripts

```bash
# scripts/build-all.sh
#!/bin/bash
set -e

echo "Building all images..."

# Build base
docker build -t stanfordhpds/base:latest base/

# Build Python images
docker build -t stanfordhpds/python-uv:latest python/uv/

# Build R images  
docker build -t stanfordhpds/r-renv:latest r/renv/

# Build extensions using templates
cd templates
./build-ssh-images.sh
./build-rstudio-images.sh

echo "All images built successfully!"
```

### 6.3 Tag and Release

```bash
# Tag base image
git tag -a v1.0.0 -m "Initial release"
git push origin v1.0.0
```

## Maintenance

### Weekly Tasks
- Review security updates
- Check for new versions of tools (uv, rig, R, Python)
- Monitor GitHub Actions for failures

### Monthly Tasks
- Update dependencies
- Review and merge community PRs
- Update documentation

### Quarterly Tasks
- Major version updates
- Performance optimization
- User feedback incorporation

## Troubleshooting

### Common Issues

1. **Multi-architecture builds fail**
   - Ensure QEMU is properly set up in GitHub Actions
   - Test locally with `docker buildx build --platform linux/amd64,linux/arm64`

2. **RStudio won't start**
   - Check that R is properly installed and in PATH
   - Verify rstudio user exists
   - Check logs: `docker logs <container>`

3. **SSH connection refused**
   - Ensure authorized_keys is mounted correctly
   - Check SSH daemon is running
   - Verify port mapping

## Next Steps

After implementation:
1. Write blog post announcing the images
2. Create video tutorials
3. Gather user feedback
4. Plan quarterly roadmap