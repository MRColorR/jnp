#!/bin/bash

if [ -n "$DOCKER_HOST" ]; then
    echo "DOCKER_HOST is set to: $DOCKER_HOST"
    /usr/bin/dockerd -H "$DOCKER_HOST"
    echo "Docker daemon starting with docker host: $DOCKER_HOST"
else
    /usr/bin/dockerd
    echo "Docker daemon starting with default host, which is a Unix socket at /var/run/docker.sock. For other hosts, specify DOCKER_HOST environment variable"
fi
