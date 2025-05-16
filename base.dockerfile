# Use Ubuntu 24.04 LTS as default base image
ARG DISTRIB_IMAGE=ubuntu
ARG DISTRIB_RELEASE=24.04
FROM ${DISTRIB_IMAGE}:${DISTRIB_RELEASE}

SHELL ["/bin/bash", "-c"]
ENV DEBIAN_FRONTEND=noninteractive

# Set environment variables for language and locale
ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US:en
ENV TZ='Europe/Rome'
ENV PATH="/root/.local/bin:${PATH}"
ENV PATH="/home/ubuntu/.local/bin${PATH}"

# Set docker auto start
ENV DOCKER_AUTO_START="true"

# Copy the locale setup script and make it executable
COPY setup-locales.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/setup-locales.sh

# Ensure the system is up-to-date, install and set up locales
RUN apt-get update && \
    apt-get dist-upgrade -y && \
    apt-get install -y --no-install-recommends locales && \
    /usr/local/bin/setup-locales.sh

# Install essential packages
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    apt-utils \
    ca-certificates \
    gnupg \
    software-properties-common \
    sudo \
    systemd \
    systemd-sysv \
    tini \
    supervisor \
    bash \
    build-essential \
    locales \
    man \
    htop \
    jq \
    curl \
    wget \
    git \
    inetutils* \
    openssh-client \
    iptables \
    python3 \
    python3-pip \
    python3-venv \
    python3-dev \
    python-is-python3 \
    pipx \
    jupyter-notebook \
    unzip \
    pigz \
    xz-utils \
    vim \
    nano \
    rsync

# Ensure pipx is installed and available
RUN pipx ensurepath

# Install Docker and Nvidia Container Toolkit
RUN mkdir -pm755 /etc/apt/keyrings && \
    curl -o /etc/apt/keyrings/docker.asc -fsSL "https://download.docker.com/linux/ubuntu/gpg" && chmod a+r /etc/apt/keyrings/docker.asc && \
    mkdir -pm755 /etc/apt/sources.list.d && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu $(grep UBUNTU_CODENAME= /etc/os-release | cut -d= -f2 | tr -d '\"') stable" > /etc/apt/sources.list.d/docker.list && \
    mkdir -pm755 /usr/share/keyrings && \
    curl -fsSL "https://nvidia.github.io/libnvidia-container/gpgkey" | gpg --dearmor -o /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg && \
    curl -fsSL "https://nvidia.github.io/libnvidia-container/stable/deb/nvidia-container-toolkit.list" | sed 's#deb https://#deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] https://#g' > /etc/apt/sources.list.d/nvidia-container-toolkit.list

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    containerd.io \
    docker-ce \
    docker-ce-cli \
    docker-buildx-plugin \
    docker-compose-plugin \
    nvidia-container-toolkit && \
    nvidia-ctk runtime configure --runtime=docker

# Enables Docker starting with systemd
RUN systemctl enable docker

# Detect architecture and install kubectl
RUN ARCH=$(dpkg --print-architecture) && \
    if [ "$ARCH" = "amd64" ]; then ARCH="amd64"; elif [ "$ARCH" = "arm64" ]; then ARCH="arm64"; fi && \
    curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/$ARCH/kubectl" && \
    curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/$ARCH/kubectl.sha256" && \
    echo "$(cat kubectl.sha256)  kubectl" | sha256sum --check && \
    sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl && \
    rm kubectl kubectl.sha256

# Install Helm using the official script
RUN curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 && \
    chmod 700 get_helm.sh && \
    ./get_helm.sh && \
    rm get_helm.sh

# Install OpenJDK
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    openjdk-21-jdk

# Install NodeJS LTS
RUN curl -sL https://deb.nodesource.com/setup_lts.x | bash - && \
    apt-get update && \
    apt-get install -y --no-install-recommends \
    nodejs

# Copy and prepare the entrypoint and modprobe
COPY modprobe entrypoint.sh /usr/local/bin/
RUN chmod 755 /usr/local/bin/entrypoint.sh /usr/local/bin/modprobe

# Copy and prepare supervisor config
COPY supervisor/supervisord.conf /etc/supervisord.conf
RUN chmod 755 /etc/supervisord.conf

# Copy and prepare config for any supervisor managed service
COPY supervisor/supervisor.d/*.conf /etc/supervisor/conf.d/
RUN chmod -R 755 /etc/supervisor/conf.d/

# Ensure the ubuntu user is part of the docker group
RUN usermod -aG docker ubuntu && \
    echo "ubuntu ALL=(ALL) NOPASSWD:ALL" >>/etc/sudoers.d/nopasswd

# Final cleanup of all apt-get operations
RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/* \
    /var/cache/debconf/* \
    /var/log/* \
    /tmp/* \
    /var/tmp/*

# Set the default user to ubuntu
USER ubuntu

# Set the working directory to the ubuntu user home directory
WORKDIR /home/ubuntu

# Set entrypoint and default command
ENTRYPOINT ["tini", "--"]
CMD ["entrypoint.sh"]
