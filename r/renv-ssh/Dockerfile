# stanfordhpds/r-renv-ssh
# R renv image with SSH server for remote development

FROM stanfordhpds/r-renv-core:latest

# Default R version if project doesn't specify one
ARG DEFAULT_R_VERSION=release

# Install OpenSSH server
RUN apt-get update && \
    apt-get install -y openssh-server && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Configure SSH
RUN mkdir /var/run/sshd && \
    # Disable password authentication for security
    sed -i 's/#PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config && \
    sed -i 's/#PubkeyAuthentication yes/PubkeyAuthentication yes/' /etc/ssh/sshd_config && \
    # Allow client to pass locale environment variables
    sed -i 's/#AcceptEnv LANG LC_\*/AcceptEnv LANG LC_\*/' /etc/ssh/sshd_config && \
    # Create privilege separation directory
    mkdir -p /run/sshd

# Create a script to set up SSH keys
RUN cat > /usr/local/bin/setup-ssh.sh << 'EOF'
#!/bin/bash
set -e

# Create SSH directory if it doesn't exist
mkdir -p /root/.ssh
chmod 700 /root/.ssh

# If authorized_keys is mounted, ensure correct permissions
if [ -f /root/.ssh/authorized_keys ]; then
    chmod 600 /root/.ssh/authorized_keys
fi

# Start SSH daemon
exec /usr/sbin/sshd -D
EOF

RUN chmod +x /usr/local/bin/setup-ssh.sh

# Expose SSH port
EXPOSE 22

# ONBUILD instructions for project-specific setup
# Copy renv files first to determine R version
ONBUILD COPY renv.lock renv.lock
ONBUILD COPY renv/activate.R renv/activate.R
ONBUILD COPY .Rprofile* ./

# Install the correct R version based on renv.lock
ONBUILD RUN DEFAULT_R_VERSION=${DEFAULT_R_VERSION} /usr/local/bin/setup-r-version.sh

# Bootstrap renv and restore packages
ONBUILD RUN if [ -f renv.lock ]; then \
        export RENV_CONFIG_REPOS_OVERRIDE=$(cat /etc/R/rspm_url) && \
        R -s -e "source('renv/activate.R'); renv::restore(); renv::status(); print(installed.packages()[,'Package'])"; \
    fi

# Copy the rest of the project
ONBUILD COPY . .

# Use the setup script as the default command
CMD ["/usr/local/bin/setup-ssh.sh"]

# Usage:
# docker build -t myproject-ssh .
# docker run -d -p 2222:22 \
#   -v ~/.ssh/id_rsa.pub:/root/.ssh/authorized_keys:ro \
#   -v $(pwd):/project \
#   myproject-ssh