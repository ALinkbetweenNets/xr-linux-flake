{
  description = "Nix flake for XR glasses on Linux - including XRLinuxDriver and Breezy Desktop";

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
      
      # Our custom library functions
      xrLib = import ./lib;
    in
    {
      # NixOS module that can be imported
      nixosModules.default = nixosModule;
      nixosModule = nixosModule; # For backwards compatibility
      
      # Expose our library functions
      lib = xrLib { lib = nixpkgs.lib; };
    } // 
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        
        packages = pkgs.callPackage ./packages {
          inherit pkgs xrealInterfaceLibrary upstream system;
        };
        
        # Define unit tests as checks
        checks = {
          lib-tests = import ./tests/unit/lib.nix { 
            inherit pkgs; 
            lib = nixpkgs.lib;
            xrLibrary = self.lib;
          };
        };
      in {
        packages = packages // {
          default = packages.xrlinuxdriver;
        };

        # Make the packages available to NixOS modules
        overlays.default = final: prev: packages;
        
        # Make checks available
        inherit checks;
        
        # Add a devShell with testing tools
        devShell = pkgs.mkShell {
          buildInputs = with pkgs; [
            nixpkgs-fmt  # Nix formatter
            nixpkgs-lint # Nix linter
          ];
          shellHook = ''
            echo "XR Linux development environment"
            echo "Run './tests/unit/run-tests.sh' to run Nix unit tests"
          '';
        };
      }
    );
}