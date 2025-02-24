# Zen Linux &nbsp; [![build-ublue](https://github.com/blue-build/template/actions/workflows/build.yml/badge.svg)](https://github.com/blue-build/template/actions/workflows/build.yml)

See the [BlueBuild docs](https://blue-build.org/how-to/setup/). 

## Installation

To rebase an existing atomic Fedora installation to the latest build:

- First rebase to the unsigned image, to get the proper signing keys and policies installed:
  ```
  sudo rpm-ostree rebase ostree-unverified-registry:ghcr.io/mecattaf/zen:latest
  ```
- Reboot to complete the rebase:
  ```
  systemctl reboot
  ```
- Then rebase to the signed image, like so:
  ```
  sudo rpm-ostree rebase ostree-image-signed:docker://ghcr.io/mecattaf/zen:latest
  ```
- Reboot again to complete the installation
  ```
  systemctl reboot
  ```
### Manual Steps

- Copy over git credentials
- Authenticate to google chrome and [follow instructions](docs/chrome.md)
- Authenticate to tailscale with `tailscale login`
- Load local models for whisper with `just whisper`
[Todo]: Load ollama models, possibly using justfile?
- GTK Settings > Select icon pack with `nwg-look`
```
systemctl --user start nextcloud
# might also need to enable nexcloud and whisper-npu
```
- Plugin local Nexcloud service to LaCie USB C drive and access on `http://0.0.0.0:8443/` then set up Celeste to sync files. In case we need to reload the nexcloud cache:
```
❯ # Run the occ scan command inside the container
  podman exec nextcloud php occ files:scan --all
```
- We also make sure to add python packages install through uv, add to justfile:
```
uv tool install --force --python python3.11 open-webui@latest
uv tool install --force --python python3.12 aider-chat@latest
```


### Troubleshooting flatpaks

If a flatpak is broken, revert versions using:
```
flatpak list
flatpak remote-info --log flathub com.google.Chrome
flatpak update --commit=<commit-of-working-version> com.google.Chrome
```

### Rolling back to previous versions

View the list of available builds by entering:
```
skopeo list-tags docker://ghcr.io/mecattaf/zen | sort -rV
```

Rebasing to a specific build requires users to open a host terminal and enter:
```
rpm-ostree rebase ostree-image-signed:docker://ghcr.io/ublue-os/IMAGE-NAME:VERSION-YEARMONTHDAY
```

Example:
```
rpm-ostree rebase ostree-image-signed:docker://ghcr.io/ublue-os/bazzite-deck:39-20240113
```
For the Jan. 13th 2024 bazzite-deck (Fedora 39) build.

### To revert back to Silverblue

```shell
sudo rpm-ostree rebase fedora:fedora/40/x86_64/silverblue
```

