# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This repository is a Nix flake that packages the XRLinuxDriver project and Breezy Desktop integrations. The XRLinuxDriver allows Linux devices to recognize supported XR glasses when plugged in and convert their movements into mouse movements and external broadcasts for games and applications. Breezy Desktop provides integration with desktop environments like GNOME and KDE to create virtual displays.

The flake aims to:
1. Implement Nix packages for the XRLinuxDriver
2. Implement Nix packages for Breezy Desktop (GNOME and KDE integrations)
3. Implement NixOS services for both
4. Eventually upstream to Nixpkgs

## Repository Structure

- `/packages/`: Contains the Nix package definitions
  - `xrlinuxdriver.nix`: XRLinuxDriver package definition
  - `breezy-desktop-common.nix`: Common files for Breezy Desktop
  - `breezy-desktop-gnome.nix`: GNOME integration package
  - `breezy-desktop-kwin.nix`: KDE/KWin integration package
  - `default.nix`: Imports and exports all packages
- `/modules/nixos/`: Contains NixOS module definitions
  - `xrlinuxdriver.nix`: XRLinuxDriver module
  - `breezy-desktop-gnome.nix`: GNOME integration module
  - `breezy-desktop-kwin.nix`: KDE integration module
  - `default.nix`: Imports and exports all modules
- `/flake.nix`: Main flake definition
- `/README.md`: Usage instructions and features

## Key Components

### XRLinuxDriver Features

The driver supports multiple XR devices:
- VITURE (One, One Lite, Pro, Luma, Luma Pro)
- TCL/RayNeo (NXTWEAR S/S+; Air 2, 2s, 3s)
- Rokid (Max, Air)
- XREAL (Air 1, 2, 2 Pro, 2 Ultra)

The driver provides:
- Automatic recognition of supported XR glasses
- Translation of head movements to mouse movements
- Adjustable sensitivity
- Optional joystick mode

### Breezy Desktop Features

Breezy Desktop extends the XRLinuxDriver functionality with:
- Virtual display support for GNOME and KDE Plasma
- Window management in virtual space
- Multiple virtual monitors
- Curved displays (on GNOME 46+)
- Keyboard shortcuts for common actions

### Package Dependencies

#### XRLinuxDriver
- CMake, pkg-config, Python 3
- libusb, libevdev, openssl, json-c, curl, wayland, libffi

#### Breezy Desktop GNOME
- meson, ninja, pkg-config
- Python 3 with pygobject3, pydbus, pyyaml
- glib, gtk3, gnome-shell, librsvg

#### Breezy Desktop KDE/KWin
- cmake, extra-cmake-modules, pkg-config
- Python 3 with pyyaml
- Qt6 (base, declarative), KDE Frameworks 6 components
- libdrm, kwin

## Common Development Tasks

### Building All Packages

```bash
nix build
```

### Building Specific Packages

```bash
nix build .#xrlinuxdriver
nix build .#breezy-desktop-gnome
nix build .#breezy-desktop-kwin
```

### Testing the Flake

```bash
nix flake check
```

### Using in NixOS Configuration

To use the XRLinuxDriver:
```nix
services.xrlinuxdriver.enable = true;
```

To use Breezy Desktop GNOME integration:
```nix
services.breezy-desktop-gnome.enable = true;
```

To use Breezy Desktop KDE integration:
```nix
services.breezy-desktop-kwin.enable = true;
```

## Additional Notes

- The XREAL integration in XRLinuxDriver is currently disabled because it requires additional git submodules
- Breezy Desktop has both free and paid features (Productivity Tier)
- The packages are built directly from source rather than using pre-built binaries
- For local development, you can modify the packages and test with `nix build .`