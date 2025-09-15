# NixOS module for XRLinuxDriver
{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.xrlinuxdriver;
in {
  options.services.xrlinuxdriver = {
    enable = mkEnableOption "XRLinuxDriver for XR glasses support";

    package = mkOption {
      type = types.package;
      default = pkgs.xrlinuxdriver;
      description = "The XRLinuxDriver package to use.";
    };

    autoStart = mkOption {
      type = types.bool;
      default = true;
      description = ''
        Whether to automatically start the XRLinuxDriver service when a supported device is connected.
      '';
    };
  };

  config = mkIf cfg.enable {
    # Make udev rules available
    services.udev.packages = [ cfg.package ];

    # Ensure required kernel modules are loaded
    boot.kernelModules = [ "uinput" ];

    # Add required packages to the system
    environment.systemPackages = [ cfg.package ];

    # Configure systemd user service to start automatically (optional based on cfg.autoStart)
    systemd.user.services.xr-driver = mkIf cfg.autoStart {
      description = "XR user-space driver";
      after = [ "network.target" ];
      wantedBy = [ "default.target" ];
      serviceConfig = {
        Type = "simple";
        Environment = "LD_LIBRARY_PATH=${cfg.package}/lib";
        ExecStart = "${cfg.package}/bin/xrDriver";
        Restart = "always";
      };
    };

    # Ensure user service persists after logout
    services.logind.extraConfig = ''
      KillUserProcesses=no
    '';
  };
}