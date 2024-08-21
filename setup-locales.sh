#!/bin/bash

# Generate the main locale
locale-gen "${LANG}"

# Ensure LANGUAGE fallback locales are available
IFS=':' read -ra LANGUAGES <<< "${LANGUAGE}"
for lang in "${LANGUAGES[@]}"; do
    if ! locale -a | grep -q "${lang%.UTF-8}.utf8"; then
        locale-gen "${lang}"
    fi
done

# Update locale settings
update-locale LANG="${LANG}" LANGUAGE="${LANGUAGE}"
