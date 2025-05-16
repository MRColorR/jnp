#!/bin/bash

# Log the start of the entrypoint
echo "[INFO] Entrypoint script started."

# Ensure DOCKER_AUTO_START is set to a valid boolean string for supervisor docker child
if [ -z "${DOCKER_AUTO_START:-}" ]; then
    echo "[WARN] DOCKER_AUTO_START is not set, defaulting to 'true'."
    export DOCKER_AUTO_START="true"
fi

# If there are any arguments, execute them
if [ $# -gt 0 ]; then
    echo "[INFO] Executing provided command: $@"
    exec "$@"
fi

# Start supervisord and its children
echo "[INFO] No extra commands provided, starting supervisord..."
exec /usr/bin/supervisord