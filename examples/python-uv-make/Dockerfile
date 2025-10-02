FROM stanfordhpds/python-uv:latest

# This will trigger the ONBUILD instructions in the parent image
# which will:
# 1. Copy pyproject.toml, uv.lock, .python-version (if they exist)
# 2. Install the correct Python version
# 3. Create virtual environment and install dependencies
# 4. Copy the rest of the project files
# 5. Install the project itself

# The working directory is already set to /workspace
# The virtual environment is already in the PATH

# Run the pipeline by default
CMD ["make", "all"]