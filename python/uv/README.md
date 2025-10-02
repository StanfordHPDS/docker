# stanfordhpds/python-uv

Docker image optimized for Python projects using uv package manager.

## Features

- Automatically detects and installs Python version from:
  - `.python-version` file
  - `pyproject.toml` requires-python
  - Falls back to Python 3.12 if not specified
- Fast dependency installation with uv
- Handles both locked (`uv.lock`) and unlocked dependencies
- ONBUILD instructions for easy project integration

## Usage

### For Your Project

Create a Dockerfile in your Python project:

```dockerfile
FROM stanfordhpds/python-uv:latest

# That's it! The ONBUILD instructions will:
# 1. Copy your pyproject.toml, uv.lock, .python-version
# 2. Install the correct Python version
# 3. Create virtual environment
# 4. Install dependencies
# 5. Copy your project files
# 6. Install your project

# Override CMD to run your application
CMD ["uv", "run", "main.py"]
```

Build and run:
```bash
docker build -t my-project .
docker run -it --rm my-project
```

### Direct Usage

```bash
# Mount your project directory
docker run -it --rm -v $(pwd):/workspace stanfordhpds/python-uv:latest

# Run a specific script
docker run --rm -v $(pwd):/workspace stanfordhpds/python-uv:latest uv run my_script.py

# Run pytest
docker run --rm -v $(pwd):/workspace stanfordhpds/python-uv:latest uv run pytest

# Run Python commands
docker run --rm -v $(pwd):/workspace stanfordhpds/python-uv:latest uv run -c "import pandas; print(pandas.__version__)"
```

## Project Structure

Your project should have:
- `pyproject.toml` (required)
- `uv.lock` (optional, recommended for reproducibility)
- `.python-version` (optional, will use DEFAULT_PYTHON_VERSION if not present)

## How It Works

The image uses ONBUILD triggers to:
1. Copy project dependency files
2. Run `uv python install` to get the right Python version
3. Run `uv venv` to create a virtual environment
4. Run `uv sync` to install dependencies
5. Copy remaining project files
6. Run `uv sync` again to install the project itself

## Environment Variables

- `UV_COMPILE_BYTECODE=1` - Compile Python files for faster startup
- `UV_LINK_MODE=copy` - Copy files instead of symlinking
- `DEFAULT_PYTHON_VERSION=3.12` - Default Python version if not specified
- Working directory: `/workspace`
- Virtual environment: `/workspace/.venv`