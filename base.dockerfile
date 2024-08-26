# Use Ubuntu 24.04 LTS as base image
FROM ubuntu:24.04

SHELL ["/bin/bash", "-c"]
ENV DEBIAN_FRONTEND=noninteractive

# Set environment variables for language and locale
ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US:en
ENV TZ='Europe/Rome'
ENV PATH="/root/.local/bin:${PATH}"
ENV PATH="/home/ubuntu/.local/bin${PATH}"

# Copy the locale setup script and make it executable
COPY setup-locales.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/setup-locales.sh

# Ensure the system is up-to-date, install and set up locales
RUN apt-get update && \ 
    apt-get full-upgrade -y && \
    apt-get install -y locales && \
    /usr/local/bin/setup-locales.sh && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install essential packages
RUN apt-get update && \
    apt-get install -y \
    apt-transport-https \
    apt-utils \
    ca-certificates \
    sudo \
    openssh-client \
    iptables \
    gnupg \
    software-properties-common \
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
    inetutils* \
    python3 \
    python3-pip \
    python3-venv \
    unzip \
    vim \
    nano \
    rsync && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Docker and Nvidia Container Toolkit keys and lists
RUN mkdir -pm755 /etc/apt/keyrings && curl -fsSL "https://download.docker.com/linux/ubuntu/gpg" | gpg --dearmor -o /etc/apt/keyrings/docker.gpg && chmod a+r /etc/apt/keyrings/docker.gpg && \
    mkdir -pm755 /etc/apt/sources.list.d && echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(grep UBUNTU_CODENAME= /etc/os-release | cut -d= -f2 | tr -d '\"') stable" > /etc/apt/sources.list.d/docker.list && \
    mkdir -pm755 /usr/share/keyrings && curl -fsSL https://nvidia.github.io/libnvidia-container/gpgkey | gpg --dearmor -o /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg && \
    curl -fsSL "https://nvidia.github.io/libnvidia-container/stable/deb/nvidia-container-toolkit.list" | sed 's#deb https://#deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] https://#g' | tee /etc/apt/sources.list.d/nvidia-container-toolkit.list > /dev/null

RUN apt-get update && \
    apt-get install -y \
    containerd.io \
    docker-ce \
    docker-ce-cli \
    docker-buildx-plugin \
    docker-compose-plugin \
    nvidia-container-toolkit && \
    nvidia-ctk runtime configure --runtime=docker && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Enables Docker starting with systemd
RUN systemctl enable docker

COPY modprobe start-docker.sh entrypoint.sh /usr/local/bin/
COPY supervisor/ /etc/supervisor/conf.d/
COPY logger.sh /opt/bash-utils/logger.sh

RUN chmod +x /usr/local/bin/start-docker.sh /usr/local/bin/entrypoint.sh /usr/local/bin/modprobe

VOLUME /var/lib/docker

# Install OpenJDK
RUN apt-get update && \
    apt-get install -y \
    openjdk-21-jdk && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install NodeJS LTS
RUN curl -sL https://deb.nodesource.com/setup_lts.x | bash - && \
    apt-get update && \
    apt-get install -y \
    nodejs && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Copy and prepare dockerd starter script called by supervisor
COPY start-dockerd.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/start-dockerd.sh


# Copy and prepare the entrypoint
COPY entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/entrypoint.sh

# Ensure the ubuntu user is part of the docker group
RUN usermod -aG docker ubuntu && \
    echo "ubuntu ALL=(ALL) NOPASSWD:ALL" >>/etc/sudoers.d/nopasswd


# Set the default user to ubuntu
USER ubuntu

# Set the working directory to the ubuntu user home directory
WORKDIR /home/ubuntu

# Set entrypoint and default command
ENTRYPOINT ["tini", "--"]
CMD ["entrypoint.sh", "bash"]
