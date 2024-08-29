#!/bin/bash

set -eu

# Function to log messages
log() {
    local message="$1"
    echo "[INFO] $message"
}

# Function to log errors
error() {
    local message="$1"
    echo "[ERROR] $message" >&2
}

# Check if LANG is set and non-empty
if [[ -n "${LANG:-}" ]]; then
    log "LANG is set to ${LANG}. Generating the main locale."
    if locale-gen "${LANG}"; then
        log "Locale ${LANG} generated successfully."
    else
        error "Failed to generate locale: ${LANG}"
        exit 1
    fi
else
    log "LANG is not set. Skipping main locale generation."
fi

# Check if LANGUAGE is set and non-empty
if [[ -n "${LANGUAGE:-}" ]]; then
    log "LANGUAGE is set to ${LANGUAGE}. Ensuring fallback locales are available."
    IFS=':' read -ra LANGUAGES <<< "${LANGUAGE}"
    for lang in "${LANGUAGES[@]}"; do
        lang_formatted="${lang%.UTF-8}.utf8"
        if ! locale -a | grep -q "^${lang_formatted}$"; then
            log "Generating fallback locale: ${lang}"
            if locale-gen "${lang}"; then
                log "Fallback locale ${lang} generated successfully."
            else
                error "Failed to generate fallback locale: ${lang}"
                exit 1
            fi
        else
            log "Fallback locale ${lang} already exists."
        fi
    done

    log "Updating locale settings: LANG=${LANG:-unset}, LANGUAGE=${LANGUAGE}"
    if update-locale LANG="${LANG}" LANGUAGE="${LANGUAGE}"; then
        log "Locale settings updated successfully."
    else
        error "Failed to update locale settings."
        exit 1
    fi
else
    log "LANGUAGE is not set. Skipping fallback locale generation and locale settings update."
fi

log "Locale setup script completed."
