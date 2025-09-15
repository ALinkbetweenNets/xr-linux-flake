# xr-linux-flake

A Nix flake providing packages and services related to the XRLinuxDriver project and Breezy Desktop integrations.

The original projects can be found here:
- [XRLinuxDriver](https://github.com/wheaney/XRLinuxDriver)
- [Breezy Desktop](https://github.com/wheaney/breezy-desktop)

## Goals

- [x] Implement Nix packages for XRLinuxDriver
- [x] Implement Nix services for XRLinuxDriver
- [x] Implement Breezy Desktop integration for GNOME and KDE
- [x] Add test infrastructure with pre-commit hooks
- [ ] Validation testing on NixOS
- [ ] Upstream to Nixpkgs

## Usage

### Installing the Packages

#### Standalone Usage

You can run the driver directly without installing it permanently:

```bash
nix run github:tcarrio/xr-linux-flake
```

#### Installing via Home Manager

Add the flake to your Home Manager configuration:

```nix
{
  inputs = {
    # ... your other inputs
    xr-linux-flake.url = "github:tcarrio/xr-linux-flake";
  };

  outputs = { self, nixpkgs, home-manager, xr-linux-flake, ... }:
    {
      homeConfigurations.your-username = home-manager.lib.homeManagerConfiguration {
        # ... your other configuration
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        extraSpecialArgs = { inherit xr-linux-flake; };
        modules = [
          ({ pkgs, xr-linux-flake, ... }: {
            home.packages = [
              xr-linux-flake.packages.x86_64-linux.xrlinuxdriver
              # For GNOME integration:
              xr-linux-flake.packages.x86_64-linux.breezy-desktop-gnome
              # For KDE integration:
              # xr-linux-flake.packages.x86_64-linux.breezy-desktop-kwin
            ];
          })
        ];
      };
    };
}
```

### NixOS Module

#### Basic XRLinuxDriver

To enable the driver system-wide, add the flake to your NixOS configuration:

```nix
{
  inputs = {
    # ... your other inputs
    xr-linux-flake.url = "github:tcarrio/xr-linux-flake";
  };

  outputs = { self, nixpkgs, xr-linux-flake, ... }:
    {
      nixosConfigurations.your-hostname = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          xr-linux-flake.nixosModules.default
          {
            services.xrlinuxdriver = {
              enable = true;
              autoStart = true; # Optional, defaults to true
            };
          }
        ];
      };
    };
}
```

#### GNOME Integration

To enable the Breezy Desktop GNOME integration:

```nix
{
  services.xrlinuxdriver.enable = true;
  services.breezy-desktop-gnome.enable = true;
}
```

#### KDE/KWin Integration

To enable the Breezy Desktop KDE/KWin integration:

```nix
{
  services.xrlinuxdriver.enable = true;
  services.breezy-desktop-kwin.enable = true;
}
```

## Features

This flake provides:

1. The `xrlinuxdriver` package containing:
   - The main `xrDriver` binary
   - Helper scripts for configuration
   - Required libraries
   - udev rules for device detection

2. Breezy Desktop integration packages:
   - `breezy-desktop-gnome`: GNOME Shell integration
   - `breezy-desktop-kwin`: KDE Plasma 6 integration
   - `breezy-desktop-common`: Shared resources

3. NixOS modules for system integration:
   - XRLinuxDriver base configuration
   - GNOME desktop integration
   - KDE/KWin desktop integration

## Supported Devices

Check the [upstream project](https://github.com/wheaney/XRLinuxDriver#supported-devices) for the list of supported XR glasses.

## Breezy Desktop Features

The Breezy Desktop integrations provide:

- Virtual display functionality for XR glasses
- Window management and positioning
- Curved displays (on GNOME 46+)
- Multiple virtual monitors
- Keyboard shortcuts for common actions

Note that some features may be part of the paid "Productivity Tier" - see the [Breezy Desktop pricing](https://github.com/wheaney/breezy-desktop#breezy-desktop-pricing-productivity-tier) for details.

## Development

### Pre-commit Hooks

This repository includes pre-commit hooks that run tests and builds before each commit. To install them:

```bash
./install-hooks.sh
```

Alternatively, use the Nix development shell which automatically installs the hooks:

```bash
nix develop
```

The hooks ensure that:
1. All tests pass with `./tests/run-tests.sh`
2. All packages build correctly
3. The development shell works as expected

### Running Tests Manually

To run all tests manually:

```bash
./tests/run-tests.sh
```

### Building Individual Packages

```bash
nix build .#xrlinuxdriver
nix build .#breezy-desktop-common
nix build .#breezy-desktop-gnome
nix build .#breezy-desktop-kwin
```

