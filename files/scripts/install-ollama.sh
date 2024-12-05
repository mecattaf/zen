#!/bin/sh
# Simplified Ollama installer for Linux/x86_64
# Inspiration: https://ollama.com/install.sh
# Changes:  
# 1) Only handles x86_64 architecture (though we'll keep the check)
# 2) Removes WSL-related code
# 3) Removes all GPU-related checks and driver installations
# 4) Just focuses on downloading and placing the binary correctly
# ie. the systemd services etc. are handled separately according to bluebuild convention

set -oue pipefail

# Enhanced status and error reporting with timestamps
status() { echo "[$(date '+%Y-%m-%d %H:%M:%S')] >>> $*" >&2; }
error() { echo "[$(date '+%Y-%m-%d %H:%M:%S')] ERROR: $*"; exit 1; }

# Create temporary workspace
TEMP_DIR=$(mktemp -d)
status "Created temporary directory: $TEMP_DIR"
cleanup() { 
    status "Cleaning up temporary directory"
    rm -rf "$TEMP_DIR"
}
trap cleanup EXIT

# Verify platform
[ "$(uname -s)" = "Linux" ] || error 'This script is intended to run on Linux only.'

# Check architecture
ARCH=$(uname -m)
status "Detected architecture: $ARCH"
case "$ARCH" in
    x86_64)
        ARCH="amd64"
        status "Converting architecture name to: amd64"
        ;;
    *)
        error "This script only supports x86_64 architecture. Detected: $ARCH"
        ;;
esac

# Version parameter handling
VER_PARAM="${OLLAMA_VERSION:+?version=$OLLAMA_VERSION}"
if [ -n "${OLLAMA_VERSION:-}" ]; then
    status "Using specified Ollama version: $OLLAMA_VERSION"
else
    status "No specific version specified, using latest"
fi

# Set and create installation directory
BINDIR="/usr/bin"
status "Target installation directory: $BINDIR"
install -o0 -g0 -m755 -d "$BINDIR" || error "Failed to create installation directory"

# Download and extract the bundle
BUNDLE_URL="https://ollama.com/download/ollama-linux-${ARCH}.tgz${VER_PARAM}"
status "Downloading bundle from: $BUNDLE_URL"

# Extract with verbose logging to see the actual paths
if ! curl --fail --show-error --location --progress-bar "$BUNDLE_URL" | tar -xvzf - -C "$TEMP_DIR"; then
    error "Failed to download or extract bundle"
fi

# Find the ollama binary in the extracted contents
if [ -f "$TEMP_DIR/bin/ollama" ]; then
    status "Found ollama binary at bin/ollama"
    OLLAMA_PATH="$TEMP_DIR/bin/ollama"
else
    error "Could not locate ollama binary in extracted archive"
fi

# Install the binary
status "Installing ollama binary to $BINDIR"
if ! install -v -o0 -g0 -m755 "$OLLAMA_PATH" "$BINDIR/ollama"; then
    error "Failed to install ollama binary"
fi

# Verify installation
if [ ! -x "$BINDIR/ollama" ]; then
    error "Installation verification failed - binary is not executable"
fi

status "Ollama installation completed successfully"

