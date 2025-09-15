{ pkgs ? import <nixpkgs> {} }:

pkgs.callPackage ./lib.nix { 
  inherit pkgs;
  lib = pkgs.lib;
  xrLibrary = import ../../lib { lib = pkgs.lib; };
}