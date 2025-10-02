# stanfordhpds/r-renv-rstudio

R renv image with RStudio Server for web-based development.

## Building

This image is built using the shared RStudio template:

```bash
./scripts/build-rstudio-images.sh
```

Or build individually:

```bash
docker build -f templates/rstudio-template.Dockerfile \
  --build-arg BASE_IMAGE=stanfordhpds/r-renv:latest \
  --build-arg WORKING_DIR=/project \
  --build-arg INSTALL_RETICULATE=false \
  -t stanfordhpds/r-renv-rstudio:latest templates
```

## Usage

```bash
# Run RStudio Server
docker run -d -p 8787:8787 \
  -v $(pwd):/project \
  stanfordhpds/r-renv-rstudio:latest

# Access RStudio at http://localhost:8787
# Username: rstudio
# Password: rstudio
```

## Features

- Based on `stanfordhpds/r-renv:latest`
- RStudio Server 2024.12.0
- Working directory: `/project`
- Default preferences for modern R development
- Includes all R renv functionality