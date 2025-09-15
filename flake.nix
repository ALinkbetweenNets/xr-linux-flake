{
  description = "Nix flake for XRLinuxDriver - a driver for XR glasses on Linux";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    xrealInterfaceLibrary = {
      url = "git+https://gitlab.com/TheJackiMonster/nrealAirLinuxDriver.git";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, flake-utils, xrealInterfaceLibrary, ... }:
    let
      # NixOS module shared across all systems
      nixosModule = import ./modules/nixos.nix;
    in
    {
      # NixOS module that can be imported
      nixosModules.default = nixosModule;
      nixosModule = nixosModule; # For backwards compatibility
    } // 
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        
        xrlinuxdriver = pkgs.stdenv.mkDerivation {
          pname = "xrlinuxdriver";
          version = "2.1.5"; # From upstream CMakeLists.txt

          src = ./upstream;

          nativeBuildInputs = with pkgs; [
            cmake
            pkg-config
            python3
            git
          ];

          buildInputs = with pkgs; [
            libusb1
            libevdev
            openssl
            json_c
            curl
            wayland
          ];

          cmakeFlags = [
            "-DCMAKE_BUILD_TYPE=Release"
          ];

          prePatch = ''
            # Create necessary directories for submodules
            mkdir -p modules/xrealInterfaceLibrary
            cp -r ${xrealInterfaceLibrary}/* modules/xrealInterfaceLibrary/
          '';

          postPatch = ''
            # Make git submodule commands do nothing (we'll handle dependencies via Nix)
            substituteInPlace CMakeLists.txt \
              --replace "execute_process(COMMAND git submodule update --init --recursive" "execute_process(COMMAND echo \"Skipping git submodule update\""
            
            # Set UA_API_SECRET to empty string if not provided
            export UA_API_SECRET_INTENTIONALLY_EMPTY=1
          '';

          installPhase = ''
            mkdir -p $out/bin

            # Install the main binary
            install -Dm755 xrDriver $out/bin/xrDriver

            # Install scripts
            mkdir -p $out/bin/bin/user
            for script in ../bin/xr_driver_*; do
              install -Dm755 $script $out/bin/
            done
            install -Dm755 ../bin/setup $out/bin/xr_driver_setup
            install -Dm755 ../bin/user/install $out/bin/bin/user/
            install -Dm755 ../bin/user/systemd_start $out/bin/bin/user/
            
            # Fix paths in scripts to point to the Nix store location
            for file in $out/bin/xr_driver_* $out/bin/bin/user/*; do
              substituteInPlace $file \
                --replace "realpath bin/" "$out/bin/bin/" \
                --replace "../bin/" "$out/bin/bin/" \
                --replace "./bin/" "$out/bin/bin/"
            done

            # Install systemd service files with path substitutions
            mkdir -p $out/lib/systemd/user
            cp -r ../systemd/* $out/lib/systemd/user/
            substituteInPlace $out/lib/systemd/user/xr-driver.service \
              --replace "{ld_library_path}" "$out/lib" \
              --replace "{bin_dir}" "$out/bin"

            # Install udev rules
            mkdir -p $out/lib/udev/rules.d
            cp -r ../udev/* $out/lib/udev/rules.d/

            # Install libraries
            mkdir -p $out/lib
            cp -r ../lib/${builtins.currentSystem == "x86_64-linux" ? "x86_64" : "aarch64"}/*.so $out/lib/ || true
          '';

          meta = with pkgs.lib; {
            description = "Linux driver for XR glasses";
            homepage = "https://github.com/wheaney/XRLinuxDriver";
            license = licenses.gpl3;
            platforms = platforms.linux;
            maintainers = [];
            mainProgram = "xrDriver";
          };
        };
      in {
        packages.default = xrlinuxdriver;

        # For convenience, also expose as xrlinuxdriver
        packages.xrlinuxdriver = xrlinuxdriver;

        # Make the package available to NixOS module
        overlays.default = final: prev: {
          xrlinuxdriver = xrlinuxdriver;
        };
      }
    );
}
