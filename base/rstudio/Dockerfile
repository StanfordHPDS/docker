# stanfordhpds/base-rstudio
# Base development image with RStudio Server for custom web-based development

FROM stanfordhpds/base:latest

# Install R (required for RStudio Server)
RUN rig install release && \
    rig default release

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

# Configure RStudio for workspace
RUN echo "session-default-working-dir=/workspace" >> /etc/rstudio/rsession.conf && \
    echo "session-default-new-project-dir=/workspace" >> /etc/rstudio/rsession.conf

# Create a default user for RStudio (required)
RUN useradd -m -s /bin/bash rstudio && \
    echo "rstudio:rstudio" | chpasswd

# Default working directory
WORKDIR /workspace

# Expose RStudio port
EXPOSE 8787

# Start RStudio Server
CMD ["/usr/lib/rstudio-server/bin/rserver", "--server-daemonize=0"]

# Usage:
# docker run -d -p 8787:8787 \
#   -v $(pwd):/workspace \
#   stanfordhpds/base-rstudio
#
# Access at http://localhost:8787
# Username: rstudio
# Password: rstudio