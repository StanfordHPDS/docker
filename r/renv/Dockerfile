# stanfordhpds/r-renv
# Optimized for running existing renv-based R projects

FROM stanfordhpds/r-renv-core:latest

# Default R version if project doesn't specify one
ARG DEFAULT_R_VERSION=release

# Copy renv files first to determine R version
ONBUILD COPY renv.lock renv.lock
ONBUILD COPY renv/activate.R renv/activate.R
ONBUILD COPY .Rprofile* ./

# Install the correct R version based on renv.lock
ONBUILD RUN DEFAULT_R_VERSION=${DEFAULT_R_VERSION} /usr/local/bin/setup-r-version.sh

# Bootstrap renv and restore packages
# Set RENV_CONFIG_REPOS_OVERRIDE to ensure binary packages are used
# Use BuildKit cache mount for faster rebuilds
# Then use renv::isolate() to convert symlinks to files for self-contained image
ONBUILD RUN --mount=type=cache,target=/renv/cache \
    if [ -f renv.lock ]; then \
        export RENV_CONFIG_REPOS_OVERRIDE=$(cat /etc/R/rspm_url) && \
        R -s -e "options(renv.config.cache.symlinks = FALSE); \
        source('renv/activate.R'); renv::restore(); renv::isolate(); renv::status()"; \
    fi

# Copy the rest of the project
ONBUILD COPY . .

# Usage:
# Build: docker build -t myproject .
# Run: docker run -it --rm myproject
#
# With external cache volume for development:
# docker run -it --rm \
#   -e "RENV_PATHS_CACHE=/renv/cache" \
#   -v "/opt/local/renv/cache:/renv/cache" \
#   -v "$(pwd):/project" \
#   myproject
