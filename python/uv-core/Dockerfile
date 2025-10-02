# stanfordhpds/python-uv-core
# Base Python image with uv setup (no ONBUILD instructions)
# This serves as the foundation for python-uv, python-uv-ssh, and python-uv-rstudio

FROM stanfordhpds/base:latest

# Default Python version if project doesn't specify one
ARG DEFAULT_PYTHON_VERSION=3.12

# Set up working directory
WORKDIR /workspace

# Configure uv for optimal performance in containers
ENV UV_COMPILE_BYTECODE=1 \
    UV_LINK_MODE=copy \
    PATH="/workspace/.venv/bin:${PATH}"

# Create a script to handle optional files
RUN cat > /usr/local/bin/setup-python-env.sh << 'EOF'
#!/bin/bash
set -e

# Check if .python-version exists, if not create with default
if [ ! -f .python-version ]; then
    echo "${DEFAULT_PYTHON_VERSION}" > .python-version
fi

# Install Python version and create venv
uv python install
uv venv

# If uv.lock exists, use it; otherwise just install from pyproject.toml
if [ -f uv.lock ]; then
    uv sync --frozen --no-install-project
else
    uv sync --no-install-project
fi
EOF

RUN chmod +x /usr/local/bin/setup-python-env.sh

# Install default Python version
RUN uv python install ${DEFAULT_PYTHON_VERSION}

# Default command
CMD ["/bin/bash"]