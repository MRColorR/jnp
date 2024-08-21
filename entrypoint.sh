#!/bin/bash

# Check if the user is root
if [ "$EUID" -ne 0 ]; then
  # If not root, use sudo
  sudo start-docker.sh

else
  # If root, call directly
  start-docker.sh
fi
# Execute the provided command
"$@"