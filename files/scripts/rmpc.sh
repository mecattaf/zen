#!/usr/bin/env bash

# Tell build process to exit if there are any errors.
set -oue pipefail

curl -Lo /tmp/rmpc.tar.gz https://github.com/mierak/rmpc/releases/download/v0.2.1/rmpc-v0.2.1-x86_64-unknown-linux-gnu.tar.gz
mkdir -p /tmp/rmpc
tar -xvf /tmp/rmpc.tar.gz -C /tmp/rmpc
cp /tmp/rmpc/rmpc /usr/local/bin
