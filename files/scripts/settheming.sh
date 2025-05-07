#!/usr/bin/env bash

# Tell build process to exit if there are any errors.
set -oue pipefail

sed -i 's/Inherits=Catppuccin-Noir-Standard-Green-Dark/Inherits=Catppuccin-SE/' /usr/share/icons/default/index.theme 
