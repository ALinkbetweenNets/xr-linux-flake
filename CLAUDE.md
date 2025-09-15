# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This repository is a Nix flake that packages the XRLinuxDriver project. The XRLinuxDriver allows Linux devices to recognize supported XR glasses when plugged in and convert their movements into mouse movements and external broadcasts for games and applications.

The upstream project source is included in the `/upstream` directory, and this flake aims to:
1. Implement Nix packages for the XRLinuxDriver
2. Implement Nix services
3. Eventually upstream to Nixpkgs

## Repository Structure

- `/upstream/`: Contains the source code for the XRLinuxDriver project
- `/README.md`: Basic information about this flake
- Other files will be created as part of developing the Nix flake

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
- Integration with other projects like Breezy for virtual display functionality

### Build System

The upstream project uses CMake with the following dependencies:
- hidapi
- json-c
- Fusion
- libevdev
- libcurl
- libwayland-client
- libusb-1.0
- openssl

## Common Development Tasks

### Building the Upstream Project

```bash
cd upstream
mkdir -p build
cd build
cmake ..
make
```

### Packaging the Upstream Project

```bash
cd upstream
bin/package
```

This will create a gzip file in the `out` directory.

### Testing the Upstream Project

```bash
cd upstream
bin/package
sudo bin/xr_driver_setup $(pwd)/build/xrDriver.tar.gz
```

## Nix Flake Development

The goal is to create a proper Nix flake for this project, which will include:

1. A `flake.nix` file that defines:
   - Packages for the XRLinuxDriver
   - NixOS services for automatic startup and device detection

2. Creating proper Nix expressions for building the driver with all its dependencies

3. Ensuring proper integration with NixOS for udev rules and systemd services

### Commands for Nix Flake Development

- Initialize the flake:
  ```bash
  nix flake init
  ```

- Update flake inputs:
  ```bash
  nix flake update
  ```

- Build the flake:
  ```bash
  nix build
  ```

- Test the flake:
  ```bash
  nix flake check
  ```