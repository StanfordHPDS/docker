# Stage 1: Install dependencies
FROM stanfordhpds/base:latest AS deps

WORKDIR /project

# Set renv cache path for BuildKit
ENV RENV_PATHS_CACHE=/renv/cache

# Install R 4.5.1
RUN rig install 4.5.1 && \
    rig default 4.5.1

# Python dependencies
COPY pyproject.toml uv.lock ./
RUN uv sync --frozen

# R dependencies
COPY renv.lock .
COPY renv/activate.R renv/
COPY .Rprofile .
# Use BuildKit cache mount for renv packages
# Then isolate to make the project self-contained
RUN --mount=type=cache,target=/renv/cache \
    R -e "source('renv/activate.R'); renv::restore(); renv::isolate()"

# Stage 2: Final image
FROM stanfordhpds/base:latest

WORKDIR /project

# Copy R installation from deps stage
COPY --from=deps /opt/R /opt/R
COPY --from=deps /usr/local/bin/R /usr/local/bin/R
COPY --from=deps /usr/local/bin/Rscript /usr/local/bin/Rscript

# Copy uv's managed Python and venv from deps stage
COPY --from=deps /root/.local/share/uv/python /root/.local/share/uv/python
COPY --from=deps /project/.venv /project/.venv
COPY --from=deps /project/pyproject.toml /project/uv.lock ./

# Copy R environment
COPY --from=deps /project/renv /project/renv
COPY --from=deps /project/.Rprofile /project/renv.lock ./
COPY --from=deps /opt/R/4.5.1/lib/R/library /opt/R/4.5.1/lib/R/library

# Copy project files
COPY Makefile .
COPY scripts/ scripts/
COPY reports/ reports/

# Ensure Python is in PATH
ENV PATH="/project/.venv/bin:${PATH}"

# Default command runs the full pipeline
CMD ["make", "all"]