{
  description = "Nix flake for XRLinuxDriver - a driver for XR glasses on Linux";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    xrealInterfaceLibrary = {
      url = "git+https://gitlab.com/TheJackiMonster/nrealAirLinuxDriver.git";
      flake = false;
    };
    upstream = {
      url = "github:wheaney/XRLinuxDriver";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, flake-utils, xrealInterfaceLibrary, upstream, ... }:
    let
      # NixOS module shared across all systems
      nixosModule = import ./modules/nixos;
    in
    {
      # NixOS module that can be imported
      nixosModules.default = nixosModule;
      nixosModule = nixosModule; # For backwards compatibility
    } // 
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        
        packages = pkgs.callPackage ./packages {
          inherit pkgs xrealInterfaceLibrary upstream system;
        };
      in {
        packages = packages // {
          default = packages.xrlinuxdriver;
        };

        # Make the packages available to NixOS modules
        overlays.default = final: prev: packages;
      }
    );
}