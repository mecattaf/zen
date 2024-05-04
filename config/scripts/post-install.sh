#!/usr/bin/env bash

# Tell build process to exit if there are any errors.
set -oue pipefail

# create new username
hostnamectl set-hostname dev

# fix to load nvim-treesitter
ln -s /usr/bin/ld.bfd /usr/local/bin/ld

# emoji picker
pip install emoji-fzf
