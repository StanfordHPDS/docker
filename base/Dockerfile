FROM ubuntu:24.04
COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /bin/

# Prevent interactive prompts during installation
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=UTC

ARG QUARTO_VERSION=1.7.23

RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y \
    software-properties-common \
    gdebi-core \
    unzip \
    sudo \
    locales \
    && locale-gen en_US.UTF-8

# Install common system libraries
RUN apt-get install -y \
    wget curl git libssl-dev libxml2-dev libgit2-dev \
    build-essential libclang-dev libgmp3-dev libglpk40 \
    libharfbuzz-dev libfribidi-dev libicu-dev libxml2 \
    libpng-dev libjpeg-dev libtiff5-dev libfontconfig1-dev \
    libfreetype-dev libcairo2-dev libxt-dev libmagick++-dev \
    libsqlite3-dev libmariadb-dev libpq-dev unixodbc-dev \
    gdal-bin libgeos-dev libproj-dev \
    zlib1g-dev libbz2-dev liblzma-dev libpcre2-dev perl \
    lsb-release gnupg


# Install rig for managing R versions
RUN curl -L https://rig.r-pkg.org/deb/rig.gpg -o /etc/apt/trusted.gpg.d/rig.gpg && \
    echo 'deb http://rig.r-pkg.org/deb rig main' | tee /etc/apt/sources.list.d/rig.list && \
    apt-get update && \
    apt-get install -y r-rig

# install ruff
RUN /usr/bin/uv tool install ruff

# install Quarto
RUN ARCH=$(uname -m) && \
    if [ "$ARCH" = "x86_64" ]; then \
        QUARTO_ARCH="amd64"; \
    elif [ "$ARCH" = "aarch64" ]; then \
        QUARTO_ARCH="arm64"; \
    else \
        echo "Unsupported architecture: $ARCH" && exit 1; \
    fi && \
    wget https://github.com/quarto-dev/quarto-cli/releases/download/v${QUARTO_VERSION}/quarto-${QUARTO_VERSION}-linux-${QUARTO_ARCH}.tar.gz && \
    tar -xzf quarto-${QUARTO_VERSION}-linux-${QUARTO_ARCH}.tar.gz && \
    mv quarto-${QUARTO_VERSION} /opt/quarto && \
    ln -s /opt/quarto/bin/quarto /usr/local/bin/quarto && \
    rm quarto-${QUARTO_VERSION}-linux-${QUARTO_ARCH}.tar.gz

# Install TinyTex
RUN perl -mFile::Find /dev/null && \
    wget -qO- "https://yihui.org/tinytex/install-bin-unix.sh" | sh

# Install GitHub CLI and set up git
RUN mkdir -p -m 755 /etc/apt/keyrings && \
    wget -qO- https://cli.github.com/packages/githubcli-archive-keyring.gpg | \
    tee /etc/apt/keyrings/githubcli-archive-keyring.gpg > /dev/null && \
    chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | \
    tee /etc/apt/sources.list.d/github-cli.list > /dev/null && \
    apt-get update && \
    apt-get install -y gh

RUN git config --global init.defaultBranch main
