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

# Check for required commands
for cmd in curl tar install mkdir; do
    if ! command -v "$cmd" >/dev/null 2>&1; then
        error "Required command '$cmd' not found. Please install it first."
    fi
done

# Create and manage temporary workspace with verbose logging
TEMP_DIR=$(mktemp -d)
status "Created temporary directory: $TEMP_DIR"
cleanup() { 
    status "Cleaning up temporary directory"
    rm -rf "$TEMP_DIR"
}
trap cleanup EXIT

# Verify we're on Linux
if [ "$(uname -s)" != "Linux" ]; then
    error 'This script is intended to run on Linux only.'
fi

# Check and verify architecture
ARCH=$(uname -m)
status "Detected architecture: $ARCH"

case "$ARCH" in
    x86_64)
        ARCH="amd64"
        status "Converting architecture name to: $ARCH"
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

# Set installation directory
BINDIR="/usr/bin"
status "Target installation directory: $BINDIR"

# Create installation directory with error checking
status "Creating installation directory"
if ! install -o0 -g0 -m755 -d "$BINDIR"; then
    error "Failed to create installation directory: $BINDIR"
fi

# First attempt: Try downloading and extracting the bundle
BUNDLE_URL="https://ollama.com/download/ollama-linux-${ARCH}.tgz${VER_PARAM}"
status "Attempting to download bundle from: $BUNDLE_URL"

if curl -I --silent --fail --location "$BUNDLE_URL" >/dev/null; then
    status "Downloading Linux ${ARCH} bundle"
    if ! curl --fail --show-error --location --progress-bar "$BUNDLE_URL" | tar -xvzf - -C "$TEMP_DIR"; then
        error "Failed to download or extract bundle"
    fi
    
    status "Listing contents of temporary directory:"
    ls -la "$TEMP_DIR"
    
    if [ ! -f "$TEMP_DIR/ollama" ]; then
        status "Bundle extraction didn't produce expected binary, falling back to direct binary download"
        # Fallback to direct binary download
        BINARY_URL="https://ollama.com/download/ollama-linux-${ARCH}${VER_PARAM}"
        status "Downloading standalone binary from: $BINARY_URL"
        if ! curl --fail --show-error --location --progress-bar "$BINARY_URL" -o "$TEMP_DIR/ollama"; then
            error "Failed to download standalone binary"
        fi
    fi
else
    # Direct binary download if bundle is not available
    BINARY_URL="https://ollama.com/download/ollama-linux-${ARCH}${VER_PARAM}"
    status "Bundle not available, downloading standalone binary from: $BINARY_URL"
    if ! curl --fail --show-error --location --progress-bar "$BINARY_URL" -o "$TEMP_DIR/ollama"; then
        error "Failed to download standalone binary"
    fi
fi

# Install the binary
status "Installing ollama binary to $BINDIR"
if ! install -v -o0 -g0 -m755 "$TEMP_DIR/ollama" "$BINDIR/ollama"; then
    error "Failed to install ollama binary"
fi

# Verify installation
if [ ! -x "$BINDIR/ollama" ]; then
    error "Installation verification failed - binary is not executable"
fi

# Verify binary architecture
BINARY_ARCH=$(file "$BINDIR/ollama" | grep -o "x86-64\|amd64" || echo "unknown")
status "Installed binary architecture: $BINARY_ARCH"
if [[ "$BINARY_ARCH" != "x86-64" && "$BINARY_ARCH" != "amd64" ]]; then
    error "Installed binary architecture mismatch: expected x86-64/amd64, got $BINARY_ARCH"
fi

status "Ollama installation completed successfully"
