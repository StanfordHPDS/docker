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
| `stanfordhpds/base-rstudio` | Base + RStudio Server | For custom web-based development |
| `stanfordhpds/python-uv` | Python development with uv | Auto-detects Python version, fast dependency installation |
| `stanfordhpds/python-uv-ssh` | Python + SSH server | Remote development with Positron |
| `stanfordhpds/python-uv-rstudio` | Python + RStudio Server | Web-based IDE with Python support |
| `stanfordhpds/r-renv` | R development with renv | Auto-detects R version, reproducible environments |
| `stanfordhpds/r-renv-ssh` | R + SSH server | Remote R development |
| `stanfordhpds/r-renv-rstudio` | R + RStudio Server | Full RStudio IDE experience |

## Examples

See the [`examples/`](examples/) directory for complete project examples:
- [Python pipeline with uv and Make](examples/python-uv-make/)
- [R pipeline with renv and targets](examples/r-renv-targets/)

## Building Images Locally

```bash
# Build base image
docker build -t stanfordhpds/base:latest base/

# Build Python images
docker build -t stanfordhpds/python-uv:latest python/uv/

# Build extension images
./scripts/build-ssh-images.sh
./scripts/build-rstudio-images.sh
```

## Documentation

- [Architecture Overview](docs/architecture.md)
- [Implementation Guide](docs/implementation-guide.md)
- [Contributing Guidelines](docs/contributing.md)

## License

MIT License - see [LICENSE](LICENSE) file for details.