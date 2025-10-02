# stanfordhpds/python-uv-rstudio

Python uv image with RStudio Server for web-based development with Python support.

## Building

This image is built using the shared RStudio template:

```bash
./scripts/build-rstudio-images.sh
```

Or build individually:

```bash
docker build -f templates/rstudio-template.Dockerfile \
  --build-arg BASE_IMAGE=stanfordhpds/python-uv:latest \
  --build-arg WORKING_DIR=/workspace \
  --build-arg INSTALL_RETICULATE=true \
  -t stanfordhpds/python-uv-rstudio:latest templates
```

## Usage

```bash
# Run RStudio Server
docker run -d -p 8787:8787 \
  -v $(pwd):/workspace \
  stanfordhpds/python-uv-rstudio:latest

# Access RStudio at http://localhost:8787
# Username: rstudio
# Password: rstudio
```

## Features

- Based on `stanfordhpds/python-uv:latest`
- RStudio Server 2024.12.0
- Working directory: `/workspace`
- Python integration via reticulate
- Virtual environment at `/workspace/.venv`
- Includes all Python uv functionality