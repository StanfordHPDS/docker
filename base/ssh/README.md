# stanfordhpds/base-ssh

Base development image with SSH server for custom remote development setups.

## Features

- Ubuntu 24.04 base
- SSH server configured for public key authentication
- Pre-installed development tools (git, curl, wget, etc.)
- uv for Python package management
- rig for R version management
- Quarto for literate programming

## Usage

### Basic SSH Server

```bash
docker run -d -p 2222:22 \
  -v ~/.ssh/id_rsa.pub:/root/.ssh/authorized_keys:ro \
  -v $(pwd):/workspace \
  stanfordhpds/base-ssh

# Connect via SSH
ssh -p 2222 root@localhost
```

### As a Base for Custom Images

```dockerfile
FROM stanfordhpds/base-ssh

# Install your language/tools
RUN apt-get update && \
    apt-get install -y your-packages && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Your custom setup
WORKDIR /app
```

### With Docker Compose

```yaml
services:
  dev:
    image: stanfordhpds/base-ssh
    ports:
      - "2222:22"
    volumes:
      - ~/.ssh/authorized_keys:/root/.ssh/authorized_keys:ro
      - .:/workspace
```

## Security Notes

- Password authentication is disabled
- Only public key authentication is allowed
- Mount your public key to `/root/.ssh/authorized_keys`