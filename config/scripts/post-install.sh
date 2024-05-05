#!/usr/bin/env bash

# Tell build process to exit if there are any errors.
set -oue pipefail

# fix to load nvim-treesitter
#ln -s /usr/bin/ld.bfd /usr/local/bin/ld

# emoji picker
pip install --prefix=/usr/lib/python3.12/site-packages/ emoji-fzf
