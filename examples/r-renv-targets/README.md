# R Data Science Pipeline with renv and targets

This example demonstrates a reproducible R data science workflow using:
- `renv` for R package dependency management
- `targets` for pipeline orchestration
- Docker for complete reproducibility

## Project Structure

```
r-renv-targets/
├── Dockerfile
├── _targets.R
├── renv.lock
├── renv/
│   └── activate.R
├── .Rprofile
├── R/
│   └── functions.R
├── data/
│   ├── raw/
│   └── processed/
├── reports/
│   └── analysis.qmd
└── outputs/
    ├── figures/
    └── reports/
```

## Usage

### Local Development

```r
# Restore packages
renv::restore()

# Run the full pipeline
targets::tar_make()

# Visualize the pipeline
targets::tar_visnetwork()

# Load specific targets
targets::tar_load(processed_data)
```

### Docker

```bash
# Build and run analysis with docker compose
docker compose up --build

# Run without rebuilding
docker compose up

# Run interactively
docker compose run --rm analysis R

# Run specific command
docker compose run --rm analysis R -e "targets::tar_visnetwork()"
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
# Start RStudio Server
docker compose --profile rstudio up -d

# Access at http://localhost:8787 (username: rstudio, password: rstudio)
```

#### VS Code Dev Containers

Open the project in VS Code and select "Reopen in Container" to use the preconfigured dev container environment.

## Pipeline Steps

The pipeline is defined in `_targets.R` and includes:
1. **Data Import**: Read raw data files
2. **Data Processing**: Clean and transform data
3. **Analysis**: Statistical modeling
4. **Visualization**: Create figures
5. **Report**: Render Quarto document

## Reproducibility

- R version locked in `renv.lock`
- All package versions locked with renv
- Docker image ensures system-level reproducibility
- targets tracks dependencies and rebuilds only what's necessary