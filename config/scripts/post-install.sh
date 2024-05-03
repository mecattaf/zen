#!/usr/bin/env bash

# Tell this script to exit if there are any errors.
# You should have this in every custom script, to ensure that your completed
# builds actually ran successfully without any errors!

# Tell build process to exit if there are any errors.
set -oue pipefail

# set sddm as default display-manager
systemctl set-default graphical.target

# tailscale
systemctl enable tailscaled.service

# create new username
hostnamectl set-hostname dev

# ublue flatpak manager (?)
# note where bluefin saves the flatpaks: https://github.com/ublue-os/bluefin/tree/68b658fa06c22e9ab9a84615c52ae406b1dd021b/usr/etc/flatpak
# has system and user folders
#systemctl --global enable ublue-user-flatpak-manager.service 

# flatpak overrides
#flatpak --user override --filesystem=~/.themes
#flatpak --user override --filesystem=~/.icons
flatpak --user override --env=GTK_THEME=Catppuccin-Mocha-Standard-Green-Dark

# fix to load nvim-treesitter
sudo ln -s /usr/bin/ld.bfd /usr/local/bin/ld

# emoji picker
pip install emoji-fzf


