# Use Ubuntu 24.04 LTS as base image
FROM mrcolorrain/jnp:base

SHELL ["/bin/bash", "-c"]
ENV DEBIAN_FRONTEND=noninteractive

# Set environment variables for language and locale
ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US:en
ENV TZ='Europe/Rome'
ENV PATH="/root/.local/bin:${PATH}"
ENV PATH="/home/coder/.local/bin${PATH}"

# Set the current user to root to do operations on the image
USER root

# Remove the 'ubuntu' user to free up UID 1000 for another user
RUN touch /var/mail/ubuntu && chown ubuntu /var/mail/ubuntu && userdel -r ubuntu

# Add a user `coder` so that you're not developing as the `root` user
RUN useradd coder \
    --create-home \
    --shell=/bin/bash \
    --groups=docker \
    --uid=1000 \
    --user-group && \
    echo "coder ALL=(ALL) NOPASSWD:ALL" >>/etc/sudoers.d/nopasswd

# Set the default user to coder
USER coder

# Set the working directory to the coder user home directory
WORKDIR /home/coder

# Set entrypoint and default command
ENTRYPOINT ["tini", "--"]
CMD ["entrypoint.sh"]
