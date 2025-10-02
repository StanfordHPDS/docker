# stanfordhpds/r-renv

Docker image optimized for R projects using renv package manager.

## Features

- Automatically detects and installs R version from `renv.lock`
- Falls back to latest R release if not specified
- Multi-stage build for efficient caching
- renv bootstraps automatically from `renv/activate.R`
- Pre-configured CRAN mirror for fast package installation

## Usage

### For Your Project

Create a Dockerfile in your R project:

```dockerfile
FROM stanfordhpds/r-renv:latest

# That's it! The ONBUILD instructions will:
# 1. Copy renv.lock and renv/activate.R
# 2. Install the R version specified in renv.lock
# 3. Restore all packages
# 4. Copy your project files

# Override CMD to run your analysis
CMD ["R", "-e", "targets::tar_make()"]
```

Build and run:
```bash
docker build -t my-analysis .
docker run -it --rm my-analysis
```

### Direct Usage

```bash
# Mount your project directory
docker run -it --rm -v $(pwd):/project stanfordhpds/r-renv:latest

# Run a specific R script
docker run --rm -v $(pwd):/project stanfordhpds/r-renv:latest Rscript analysis.R

# Run R commands
docker run --rm -v $(pwd):/project stanfordhpds/r-renv:latest R -e "renv::status()"
```

## Project Structure

Your project should have:
- `renv.lock` (required)
- `renv/activate.R` (required)
- `.Rprofile` (optional)

## How It Works

The image uses a multi-stage build:

**Stage 1 (base)**:
1. Extracts R version from `renv.lock` using jq
2. Installs the exact R version with rig
3. Copies renv files and restores packages
4. Creates cache in the image for faster builds

**Stage 2 (final)**:
1. Copies R installation and packages from base stage
2. Copies your project files
3. Sets up the environment

## Environment Variables

- `RENV_PATHS_CACHE=/project/renv/.cache` - Package cache in image
- `RENV_PATHS_LIBRARY=/project/renv/library` - Package library
- `DEFAULT_R_VERSION=release` - Default R version if not in lock file
- Working directory: `/project`

## Using External Cache

For development with a shared cache:

```bash
docker run -it --rm \
  -e "RENV_PATHS_CACHE=/renv/cache" \
  -v "/opt/local/renv/cache:/renv/cache" \
  -v "$(pwd):/project" \
  stanfordhpds/r-renv:latest
```