# xrlinuxdriver-flake

A Nix flake providing packages and services related to the XRLinuxDriver project.

The original project can be found [here](https://github.com/wheaney/XRLinuxDriver.git).

## Goals

[x] - Implement Nix packages
[x] - Implement Nix services
[ ] - Upstream to Nixpkgs

## Usage

### Installing the Package

#### Standalone Usage

You can run the driver directly without installing it permanently:

```bash
nix run github:tcarrio/xrlinuxdriver-flake
```

#### Installing via Home Manager

Add the flake to your Home Manager configuration:

```nix
{
  inputs = {
    # ... your other inputs
    xrlinuxdriver-flake.url = "github:tcarrio/xrlinuxdriver-flake";
  };

  outputs = { self, nixpkgs, home-manager, xrlinuxdriver-flake, ... }:
    {
      homeConfigurations.your-username = home-manager.lib.homeManagerConfiguration {
        # ... your other configuration
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        extraSpecialArgs = { inherit xrlinuxdriver-flake; };
        modules = [
          ({ pkgs, xrlinuxdriver-flake, ... }: {
            home.packages = [
              xrlinuxdriver-flake.packages.x86_64-linux.xrlinuxdriver
            ];
          })
        ];
      };
    };
}
```

### NixOS Module

To enable the driver system-wide, add the flake to your NixOS configuration:

```nix
{
  inputs = {
    # ... your other inputs
    xrlinuxdriver-flake.url = "github:tcarrio/xrlinuxdriver-flake";
  };

  outputs = { self, nixpkgs, xrlinuxdriver-flake, ... }:
    {
      nixosConfigurations.your-hostname = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          xrlinuxdriver-flake.nixosModules.default
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

## Features

This flake provides:

1. The `xrlinuxdriver` package containing:
   - The main `xrDriver` binary
   - Helper scripts for configuration
   - Required libraries
   - udev rules for device detection

2. A NixOS module that sets up:
   - System integration via udev rules
   - Automatic loading of required kernel modules
   - A systemd user service for running the driver

## Supported Devices

Check the [upstream project](https://github.com/wheaney/XRLinuxDriver#supported-devices) for the list of supported XR glasses.

