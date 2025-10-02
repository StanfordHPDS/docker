# stanfordhpds/base-rstudio

Base development image with RStudio Server for custom web-based development.

## Features

- Ubuntu 24.04 base
- RStudio Server for web-based development
- Pre-installed development tools (git, curl, wget, etc.)
- uv for Python package management
- rig for R version management
- Quarto for literate programming
- R (latest release) pre-installed

## Usage

### Basic RStudio Server

```bash
docker run -d -p 8787:8787 \
  -v $(pwd):/workspace \
  stanfordhpds/base-rstudio

# Access at http://localhost:8787
# Username: rstudio
# Password: rstudio
```

### As a Base for Custom Images

```dockerfile
FROM stanfordhpds/base-rstudio

# Install R packages
RUN R -e "install.packages(c('tidyverse', 'shiny'), repos='https://cloud.r-project.org')"

# Install Python packages
RUN uv pip install pandas numpy matplotlib

# Your custom setup
WORKDIR /app
```

### With Docker Compose

```yaml
services:
  rstudio:
    image: stanfordhpds/base-rstudio
    ports:
      - "8787:8787"
    volumes:
      - .:/workspace
    environment:
      - PASSWORD=mysecretpassword  # Override default password
```

## Customization

### Change Password

Set the PASSWORD environment variable:

```bash
docker run -d -p 8787:8787 \
  -e PASSWORD=mysecretpassword \
  -v $(pwd):/workspace \
  stanfordhpds/base-rstudio
```

### Add Additional Users

Create a custom image:

```dockerfile
FROM stanfordhpds/base-rstudio

RUN useradd -m -s /bin/bash analyst && \
    echo "analyst:analyst123" | chpasswd
```

## RStudio Configuration

Default preferences set in `/etc/rstudio/rstudio-prefs.json`:
- Native pipe operator (`|>`) insertion enabled
- Workspace saving disabled
- Rainbow parentheses enabled
- Default working directory set to `/workspace`