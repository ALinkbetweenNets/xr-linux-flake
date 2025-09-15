# NixOS module for XRLinuxDriver and Breezy Desktop
{ config, lib, pkgs, ... }:

let 
  xrlinuxdriverModule = import ./xrlinuxdriver.nix;
  breezyGnomeModule = import ./breezy-desktop-gnome.nix;
  breezyKwinModule = import ./breezy-desktop-kwin.nix;
in

{
  imports = [
    ./xrlinuxdriver.nix
    ./breezy-desktop-gnome.nix
    ./breezy-desktop-kwin.nix
  ];

  # Optional: Add meta information for the module
  meta = {
    maintainers = [];
    doc = "NixOS modules for XRLinuxDriver and Breezy Desktop integrations";
  };
}