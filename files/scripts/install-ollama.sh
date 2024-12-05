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

# Simple status and error reporting
status() { echo ">>> $*" >&2; }
error() { echo "ERROR: $*"; exit 1; }

# Create and manage temporary workspace
TEMP_DIR=$(mktemp -d)
cleanup() { rm -rf "$TEMP_DIR"; }
trap cleanup EXIT

# Check platform and architecture
[ "$(uname -s)" = "Linux" ] || error 'This script is intended to run on Linux only.'
ARCH=$(uname -m)
case "$ARCH" in
    x86_64) ARCH="amd64" ;;
    *) error "This script only supports x86_64 architecture." ;;
esac

# Version parameter handling from original script
VER_PARAM="${OLLAMA_VERSION:+?version=$OLLAMA_VERSION}"

# Set installation directory - using /usr/bin for atomic system compatibility
BINDIR="/usr/bin"

# Install binary
status "Installing ollama to $BINDIR"
install -o0 -g0 -m755 -d $BINDIR

# Try bundle first, fallback to standalone binary if bundle fails
if curl -I --silent --fail --location "https://ollama.com/download/ollama-linux-${ARCH}.tgz${VER_PARAM}" >/dev/null ; then
    status "Downloading Linux ${ARCH} bundle"
    curl --fail --show-error --location --progress-bar \
        "https://ollama.com/download/ollama-linux-${ARCH}.tgz${VER_PARAM}" | \
        tar -xzf - -C "$TEMP_DIR"
        
    if [ ! -f "$TEMP_DIR/ollama" ]; then
        error "Ollama binary not found in extracted archive"
    fi
    
    install -v -o0 -g0 -m755 "$TEMP_DIR/ollama" "$BINDIR/ollama"
else
    status "Downloading Linux ${ARCH} CLI"
    curl --fail --show-error --location --progress-bar \
        "https://ollama.com/download/ollama-linux-${ARCH}${VER_PARAM}" \
        -o "$TEMP_DIR/ollama"
    
    install -v -o0 -g0 -m755 "$TEMP_DIR/ollama" "$BINDIR/ollama"
fi

# Verify successful installation
if [ ! -x "$BINDIR/ollama" ]; then
    error "Installation verification failed"
fi

status "Ollama installation complete"
