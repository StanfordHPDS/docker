# stanfordhpds/r-renv-rstudio
# R renv image with RStudio Server for web-based development

FROM stanfordhpds/r-renv-core:latest

# Default R version if project doesn't specify one
ARG DEFAULT_R_VERSION=release

# Download and install RStudio Server
# Note: Only stable releases available for amd64, arm64 requires daily builds
RUN ARCH=$(dpkg --print-architecture) && \
    if [ "$ARCH" = "amd64" ]; then \
        # Use stable release for amd64
        RSTUDIO_VERSION="2024.09.0-375"; \
        RSTUDIO_URL="https://download2.rstudio.org/server/jammy/amd64/rstudio-server-${RSTUDIO_VERSION}-amd64.deb"; \
    else \
        # Use daily build for arm64 (no stable releases available)
        RSTUDIO_VERSION="2025.09.1-401"; \
        RSTUDIO_URL="https://s3.amazonaws.com/rstudio-ide-build/server/jammy/arm64/rstudio-server-${RSTUDIO_VERSION}-arm64.deb"; \
    fi && \
    wget -q $RSTUDIO_URL -O rstudio-server.deb && \
    gdebi -n rstudio-server.deb && \
    rm rstudio-server.deb

# Configure RStudio Server preferences
RUN echo '{ \
    "insert_native_pipe_operator": true, \
    "save_workspace": "never", \
    "load_workspace": "never", \
    "rainbow_parentheses": true, \
    "rainbow_fenced_divs": true \
}' > /etc/rstudio/rstudio-prefs.json

# Configure RStudio for project workspace
RUN echo "session-default-working-dir=/project" >> /etc/rstudio/rsession.conf && \
    echo "session-default-new-project-dir=/project" >> /etc/rstudio/rsession.conf

# Create a default user for RStudio (required)
RUN useradd -m -s /bin/bash rstudio && \
    echo "rstudio:rstudio" | chpasswd

# Expose RStudio port
EXPOSE 8787

# ONBUILD instructions for project-specific setup
# Copy renv files first to determine R version
ONBUILD COPY renv.lock renv.lock
ONBUILD COPY renv/activate.R renv/activate.R
ONBUILD COPY .Rprofile* ./

# Install the correct R version based on renv.lock
ONBUILD RUN DEFAULT_R_VERSION=${DEFAULT_R_VERSION} /usr/local/bin/setup-r-version.sh

# Bootstrap renv and restore packages
ONBUILD RUN if [ -f renv.lock ]; then \
        export RENV_CONFIG_REPOS_OVERRIDE=$(cat /etc/R/rspm_url) && \
        R -s -e "source('renv/activate.R'); renv::restore(); renv::status(); print(installed.packages()[,'Package'])"; \
    fi

# Copy the rest of the project
ONBUILD COPY . .

# Start RStudio Server
CMD ["/usr/lib/rstudio-server/bin/rserver", "--server-daemonize=0"]

# Usage:
# docker build -t myproject-rstudio .
# docker run -d -p 8787:8787 myproject-rstudio
# Access at http://localhost:8787
# Username: rstudio
# Password: rstudio