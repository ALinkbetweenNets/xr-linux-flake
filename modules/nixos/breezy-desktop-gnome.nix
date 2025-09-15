# NixOS module for Breezy Desktop GNOME integration
{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.breezy-desktop-gnome;
in {
  options.services.breezy-desktop-gnome = {
    enable = mkEnableOption "Breezy Desktop GNOME integration for XR glasses";

    package = mkOption {
      type = types.package;
      default = pkgs.breezy-desktop-gnome;
      description = "The Breezy Desktop GNOME package to use.";
    };
  };

  config = mkIf cfg.enable {
    # Enable the xrlinuxdriver service
    services.xrlinuxdriver.enable = true;

    # Add required packages to the system
    environment.systemPackages = [
      cfg.package
    ];

    # Add GNOME extension
    services.gnome.gnome-browser-connector.enable = true;

    # Ensure GNOME Shell is installed
    services.xserver.desktopManager.gnome.enable = true;
    
    # Add user setup instructions
    environment.sessionVariables.BREEZY_DESKTOP_GNOME_SETUP_INSTRUCTIONS = ''
      To complete the setup, run:
      1. breezy-desktop-gnome-setup
      2. Log out and back in
    '';
  };
}