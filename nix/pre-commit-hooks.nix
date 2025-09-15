{
  description = "Git hooks for XR Linux Flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    pre-commit-hooks.url = "github:cachix/pre-commit-hooks.nix";
  };

  outputs = { self, nixpkgs, flake-utils, pre-commit-hooks }:
    flake-utils.lib.eachDefaultSystem (system:
      let 
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        checks = {
          pre-commit-check = pre-commit-hooks.lib.${system}.run {
            src = ./.;
            hooks = {
              run-tests = {
                enable = true;
                name = "Run all tests";
                entry = "${pkgs.bash}/bin/bash -c '${self}/tests/run-tests.sh'";
                language = "system";
                pass_filenames = false;
              };
            };
          };
        };
      }
    );
}