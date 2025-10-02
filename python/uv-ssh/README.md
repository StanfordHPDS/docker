# stanfordhpds/python-uv-ssh

Python uv image with SSH server for remote development.

## Building

This image is built using the shared SSH template:

```bash
./scripts/build-ssh-images.sh
```

Or build individually:

```bash
docker build -f templates/ssh-template.Dockerfile \
  --build-arg BASE_IMAGE=stanfordhpds/python-uv:latest \
  -t stanfordhpds/python-uv-ssh:latest templates
```

## Usage

```bash
# Run with SSH access
docker run -d -p 2222:22 \
  -v ~/.ssh/id_rsa.pub:/root/.ssh/authorized_keys:ro \
  -v $(pwd):/workspace \
  stanfordhpds/python-uv-ssh:latest

# Connect via SSH
ssh -p 2222 root@localhost
```

## Features

- Based on `stanfordhpds/python-uv:latest`
- SSH server with public key authentication only
- Working directory: `/workspace`
- Includes all Python uv functionality
- Virtual environment at `/workspace/.venv`