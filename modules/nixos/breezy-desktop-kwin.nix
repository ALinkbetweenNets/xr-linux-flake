# NixOS module for Breezy Desktop KDE/KWin integration
{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.breezy-desktop-kwin;
in {
  options.services.breezy-desktop-kwin = {
    enable = mkEnableOption "Breezy Desktop KDE/KWin integration for XR glasses";

    package = mkOption {
      type = types.package;
      default = pkgs.breezy-desktop-kwin;
      description = "The Breezy Desktop KDE/KWin package to use.";
    };
  };

  config = mkIf cfg.enable {
    # Enable the xrlinuxdriver service
    services.xrlinuxdriver.enable = true;

    # Add required packages to the system
    environment.systemPackages = [
      cfg.package
    ];

    # Ensure KDE Plasma is installed
    services.xserver.desktopManager.plasma6.enable = true;
    
    # Add user setup instructions
    environment.sessionVariables.BREEZY_DESKTOP_KWIN_SETUP_INSTRUCTIONS = ''
      To complete the setup, run:
      1. breezy-desktop-kwin-setup
      2. Log out and back in
      3. For SteamOS users, run: steamos-session-select plasma-wayland-persistent
    '';
  };
}