# Python Data Science Pipeline with uv and Make

This example demonstrates a reproducible Python data science workflow using:
- `uv` for fast, reliable Python dependency management
- `make` for orchestrating the pipeline
- `quarto` for literate programming and reports
- Docker for complete reproducibility

## Project Structure

```
python-uv-make/
├── Dockerfile
├── Makefile
├── pyproject.toml
├── uv.lock
├── .python-version
├── src/
│   ├── __init__.py
│   ├── data_prep.py
│   ├── analysis.py
│   └── visualize.py
├── data/
│   ├── raw/
│   └── processed/
├── reports/
│   ├── analysis.qmd
│   └── _quarto.yml
└── outputs/
    ├── figures/
    └── reports/
```

## Usage

### Local Development

```bash
# Set up environment
make setup

# Run the full pipeline
make all

# Run specific steps
make data
make analysis
make visualize
make report

# Clean outputs
make clean
```

### Docker

```bash
# Build and run analysis with docker compose
docker compose up --build

# Run without rebuilding
docker compose up

# Run specific make target
docker compose run --rm analysis make report

# Run interactively
docker compose run --rm analysis bash
```

### Remote Development

#### SSH Access (Positron/VS Code)

1. **Ensure you have an SSH key pair** (if not, generate one):
   ```bash
   ssh-keygen -t ed25519 -C "your_email@example.com"
   ```

2. **Start the SSH service**:
   ```bash
   docker compose --profile ssh up -d
   ```

3. **Configure SSH** in `~/.ssh/config`:
   ```
   Host docker-ssh
       HostName localhost
       User root
       Port 2222
   ```

4. **Connect via SSH**:
   ```bash
   ssh docker-ssh
   ```

   Or use Positron/VS Code's Remote-SSH extension to connect to `docker-ssh`.

#### RStudio Server

```bash
# Start RStudio Server (for Python development in RStudio)
docker compose --profile rstudio up -d

# Access at http://localhost:8787 (username: rstudio, password: rstudio)
```

#### VS Code Dev Containers

Open the project in VS Code and select "Reopen in Container" to use the preconfigured dev container environment.

## Pipeline Steps

1. **Data Preparation**: Downloads and cleans raw data
2. **Analysis**: Performs statistical analysis
3. **Visualization**: Creates publication-ready figures
4. **Report**: Renders Quarto document to HTML/PDF

## Reproducibility

- Python version pinned in `.python-version`
- All dependencies locked in `uv.lock`
- Docker image ensures system-level reproducibility
- Make targets are idempotent