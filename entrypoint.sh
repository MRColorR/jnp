#!/bin/bash

# Start supervisord and its children
exec /usr/bin/supervisord

# Execute specified command
"$@"