# Shared RStudio Server configuration template
# Use with --build-arg BASE_IMAGE=<your-base-image>
# Optional: --build-arg WORKING_DIR=/workspace (default: /project)
# Optional: --build-arg INSTALL_RETICULATE=false (default: false)

ARG BASE_IMAGE
FROM ${BASE_IMAGE}

ARG WORKING_DIR=/project
ARG INSTALL_RETICULATE=false

# Download and install RStudio Server
ARG RSTUDIO_VERSION=2024.12.2+570
RUN ARCH=$(dpkg --print-architecture) && \
    if [ "$ARCH" = "amd64" ]; then \
        RSTUDIO_URL="https://download2.rstudio.org/server/jammy/amd64/rstudio-server-${RSTUDIO_VERSION}-amd64.deb"; \
    else \
        # ARM64 uses dailies
        RSTUDIO_URL="https://s3.amazonaws.com/rstudio-ide-build/server/jammy/arm64/rstudio-server-2024.12.2-570-arm64.deb"; \
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
RUN echo "session-default-working-dir=${WORKING_DIR}" >> /etc/rstudio/rsession.conf && \
    echo "session-default-new-project-dir=${WORKING_DIR}" >> /etc/rstudio/rsession.conf

# Conditionally install reticulate for Python integration
RUN if [ "$INSTALL_RETICULATE" = "true" ]; then \
        R -e "install.packages('reticulate')"; \
        echo "PATH=${WORKING_DIR}/.venv/bin:\${PATH}" >> /etc/environment; \
    fi

# Create a default user for RStudio (required)
RUN useradd -m -s /bin/bash rstudio && \
    echo "rstudio:rstudio" | chpasswd

# Expose RStudio port
EXPOSE 8787

# Start RStudio Server
CMD ["/usr/lib/rstudio-server/bin/rserver", "--server-daemonize=0"]