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

### Manual setup using GUI

- Run `nwg-look` and set up appearance settings
- Run `azote` and pick wallpaper
- Run `nautilus` and set hidden files to "show"

### Google Chrome

1) In `chrome://settings`:

System

- Continue running background apps when Google Chrome is closed ❌
- Use hardware acceleration when available ✅

Appearance

- Theme: `All Black - Full Dark Theme/Black Theme`
- Mode: `Dark`
- Show home button ❌
- Show bookmarks bar ❌
- Show images on tab hover preview cards ✅
- Use system title bars and borders ✅

2) In`chrome://flags`:

- Preferred Ozone Platform: `Wayland`
- Chrome Refresh 2023 ✅
- Realbox Chrome Refresh 2023 ✅
- Chrome WebUI Refresh 2023 ✅
- Chrome Refresh 2023 New Tab Button ✅
- Enable Display Compositor to use a new gpu thread ✅
- WebRTC PipeWire support ✅
- Native Client ✅
- WebGL Developer Extensions ✅
- WebGL Draft Extensions✅
- Toggle hardware accelerated H.264 video encoding for Cast Streaming ✅
- Toggle hardware accelerated VP8 video encoding for Cast Streaming ✅

### Troubleshooting flatpaks

If a flatpak is broken, revert versions using:
```
flatpak list
flatpak remote-info --log flathub com.google.Chrome
flatpak update --commit=<commit-of-working-version> com.google.Chrome
```

### To revert back to Silverblue

```shell
sudo rpm-ostree rebase fedora:fedora/40/x86_64/silverblue
```


## ISO

If build on Fedora Atomic, you can generate an offline ISO with the instructions available [here](https://blue-build.org/learn/universal-blue/#fresh-install-from-an-iso). 
