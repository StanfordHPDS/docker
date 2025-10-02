# stanfordhpds/python-uv
# Optimized for running existing uv-based Python projects

FROM stanfordhpds/python-uv-core:latest

# Default Python version if project doesn't specify one
ARG DEFAULT_PYTHON_VERSION=3.12

# Copy only the files that exist (handled by Docker's COPY semantics)
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

# Usage:
# Build: docker build -t myproject .
# Run: docker run -it --rm myproject
#
# With mounted workspace for development:
# docker run -it --rm \
#   -v $(pwd):/workspace \
#   myproject