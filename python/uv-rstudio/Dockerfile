# stanfordhpds/python-uv-rstudio
# Python uv image with RStudio Server for web-based development with Python support

FROM stanfordhpds/python-uv-core:latest

# Default Python version if project doesn't specify one
ARG DEFAULT_PYTHON_VERSION=3.12

# Install R for RStudio (required even for Python-focused work)
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

# Configure RStudio for project workspace
RUN echo "session-default-working-dir=/workspace" >> /etc/rstudio/rsession.conf && \
    echo "session-default-new-project-dir=/workspace" >> /etc/rstudio/rsession.conf

# Install reticulate for Python integration in RStudio
RUN R -e "install.packages('reticulate', repos='https://cloud.r-project.org')" && \
    echo "PATH=/workspace/.venv/bin:\${PATH}" >> /etc/environment

# Create a default user for RStudio (required)
RUN useradd -m -s /bin/bash rstudio && \
    echo "rstudio:rstudio" | chpasswd

# Expose RStudio port
EXPOSE 8787

# ONBUILD instructions for project-specific setup
# Copy only the files that exist
ONBUILD COPY pyproject.toml* uv.lock* .python-version* ./

# Run the setup script
ONBUILD RUN DEFAULT_PYTHON_VERSION=${DEFAULT_PYTHON_VERSION} /usr/local/bin/setup-python-env.sh

# Copy the rest of the project
ONBUILD COPY . .

# Install the project itself
ONBUILD RUN if [ -f uv.lock ]; then \
        uv sync --frozen; \
    else \
        uv sync; \
    fi

# Start RStudio Server
CMD ["/usr/lib/rstudio-server/bin/rserver", "--server-daemonize=0"]

# Usage:
# docker build -t myproject-rstudio .
# docker run -d -p 8787:8787 myproject-rstudio
# Access at http://localhost:8787
# Username: rstudio
# Password: rstudio