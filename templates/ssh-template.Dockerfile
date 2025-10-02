# Shared SSH server configuration template
# Use with --build-arg BASE_IMAGE=<your-base-image>

ARG BASE_IMAGE
FROM ${BASE_IMAGE}

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

# Use the setup script as the default command
CMD ["/usr/local/bin/setup-ssh.sh"]