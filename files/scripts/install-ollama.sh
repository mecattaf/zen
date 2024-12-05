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

# Keep the original script's status/error functions for consistent output
red="$( (/usr/bin/tput bold || :; /usr/bin/tput setaf 1 || :) 2>&-)"
plain="$( (/usr/bin/tput sgr0 || :) 2>&-)"
status() { echo ">>> $*" >&2; }
error() { echo "${red}ERROR:${plain} $*"; exit 1; }

TEMP_DIR=$(mktemp -d)
cleanup() { rm -rf $TEMP_DIR; }
trap cleanup EXIT

# Utility functions from original script
available() { command -v $1 >/dev/null; }
require() {
    local MISSING=''
    for TOOL in $*; do
        if ! available $TOOL; then
            MISSING="$MISSING $TOOL"
        fi
    done
    echo $MISSING
}

# Check platform and architecture
[ "$(uname -s)" = "Linux" ] || error 'This script is intended to run on Linux only.'
ARCH=$(uname -m)
case "$ARCH" in
    x86_64) ARCH="amd64" ;;
    *) error "This script only supports x86_64 architecture." ;;
esac

# Version parameter handling from original script
VER_PARAM="${OLLAMA_VERSION:+?version=$OLLAMA_VERSION}"

# Check for required tools
NEEDS=$(require curl grep)
if [ -n "$NEEDS" ]; then
    status "ERROR: The following tools are required but missing:"
    for NEED in $NEEDS; do
        echo "  - $NEED"
    done
    exit 1
fi

# Determine installation directory
for BINDIR in /usr/local/bin /usr/bin /bin; do
    echo $PATH | grep -q $BINDIR && break || continue
done
OLLAMA_INSTALL_DIR=$(dirname ${BINDIR})

# Install binary
status "Installing ollama to $OLLAMA_INSTALL_DIR"
install -o0 -g0 -m755 -d $BINDIR
install -o0 -g0 -m755 -d "$OLLAMA_INSTALL_DIR"

status "Downloading Linux ${ARCH} bundle"
curl --fail --show-error --location --progress-bar \
    "https://ollama.com/download/ollama-linux-${ARCH}.tgz${VER_PARAM}" | \
    tar -xzf - -C "$OLLAMA_INSTALL_DIR"

if [ "$OLLAMA_INSTALL_DIR/bin/ollama" != "$BINDIR/ollama" ] ; then
    status "Making ollama accessible in the PATH in $BINDIR"
    ln -sf "$OLLAMA_INSTALL_DIR/ollama" "$BINDIR/ollama"
fi

status "Ollama installation complete."
