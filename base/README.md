# stanfordhpds/base

Base Docker image for scientific computing with R and Python.

## What's Included

- **Operating System**: Ubuntu 24.04 LTS
- **Python Tools**: 
  - uv (ultra-fast Python package manager)
  - ruff (Python linter/formatter)
- **R Tools**:
  - rig (R installation manager)
- **Document Processing**:
  - Quarto (scientific publishing)
  - TinyTeX (LaTeX support)
- **Development Tools**:
  - Git with sensible defaults
  - GitHub CLI
  - Common build tools and libraries

## System Libraries

Pre-installed libraries for scientific computing:
- Image processing: libpng, libjpeg, libtiff, libmagick++
- Geospatial: gdal, geos, proj
- Databases: sqlite3, mariadb, postgresql, unixodbc
- XML/Web: libxml2, libcurl, libssl
- Math/Stats: gmp, glpk, harfbuzz

## Usage

This image is intended as a base for other images. For direct use:

```bash
# Run interactively
docker run -it --rm stanfordhpds/base:latest

# Check installed versions
docker run --rm stanfordhpds/base:latest uv --version
docker run --rm stanfordhpds/base:latest rig --version
docker run --rm stanfordhpds/base:latest quarto --version
```

## Building

```bash
docker build -t stanfordhpds/base:latest .
```

## Extending

Create your own Dockerfile:

```dockerfile
FROM stanfordhpds/base:latest

# Your customizations here
```