#!/usr/bin/env bash

# Tell build process to exit if there are any errors.
set -oue pipefail

# The following might have to be done manually upon first boot instead, in which case add to readme:

# 1) fix to load nvim-treesitter
#ln -s /usr/bin/ld.bfd /usr/local/bin/ld

# 2) enable or load quadlets as systemd service
#    also note useful flags -xeu in systemctl commands
#    and journalctl --user
# systemctl --user daemon-reload
# systemctl --user start {container_name}.service 
# systemctl --user list-units # --type=service

