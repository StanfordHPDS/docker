# stanfordhpds/r-renv-core
# Base R image with renv setup (no ONBUILD instructions)
# This serves as the foundation for r-renv, r-renv-ssh, and r-renv-rstudio

FROM stanfordhpds/base:latest

# Default R version if project doesn't specify one
ARG DEFAULT_R_VERSION=release

# Install jq for parsing renv.lock
RUN apt-get update && \
    apt-get install -y jq && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Configure repository based on architecture
# We'll set RENV_CONFIG_REPOS_OVERRIDE in the setup script
RUN mkdir -p /etc/R && \
    ARCH=$(dpkg --print-architecture) && \
    if [ "$ARCH" = "amd64" ]; then \
        RSPM_URL="https://packagemanager.posit.co/cran/__linux__/noble/latest"; \
    elif [ "$ARCH" = "arm64" ]; then \
        RSPM_URL="https://packagemanager.posit.co/cran/latest/bin/linux/noble-aarch64/4.5"; \
    else \
        RSPM_URL="https://cloud.r-project.org"; \
    fi && \
    echo "options(repos = c(CRAN = \"$RSPM_URL\"))" > /etc/R/Rprofile.site && \
    echo 'options(HTTPUserAgent = sprintf("R/%s R (%s)", getRversion(), paste(getRversion(), R.version["platform"], R.version["arch"], R.version["os"])))' >> /etc/R/Rprofile.site && \
    # Save the URL for later use in RENV_CONFIG_REPOS_OVERRIDE
    echo "$RSPM_URL" > /etc/R/rspm_url

# Set up working directory
WORKDIR /project

# Configure renv for better performance in containers
ENV RENV_PATHS_CACHE=/renv/cache

# Create renv cache directory with proper permissions
RUN mkdir -p /renv/cache && chmod 777 /renv/cache

# Create a script to handle R installation based on renv.lock
RUN cat > /usr/local/bin/setup-r-version.sh << 'EOF'
#!/bin/bash
set -e

# Check if renv.lock exists and has R version
if [ -f renv.lock ] && jq -e '.R.Version' renv.lock > /dev/null 2>&1; then
    R_VERSION=$(jq -r '.R.Version' renv.lock)
    echo "Installing R version $R_VERSION from renv.lock"
    rig install "$R_VERSION"
    rig default "$R_VERSION"
else
    # Use default R version
    echo "No R version found in renv.lock, using default: ${DEFAULT_R_VERSION}"
    rig install "${DEFAULT_R_VERSION}"
    rig default "${DEFAULT_R_VERSION}"
fi
EOF

RUN chmod +x /usr/local/bin/setup-r-version.sh

# Install default R version
RUN rig install "${DEFAULT_R_VERSION}" && \
    rig default "${DEFAULT_R_VERSION}"

# Default command
CMD ["R"]