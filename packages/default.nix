{
  pkgs,
  xrealInterfaceLibrary,
  upstream,
  system,
  ...
}:

let
  xrlinuxdriver = pkgs.callPackage ./xrlinuxdriver.nix {
    inherit xrealInterfaceLibrary upstream system;
  };
  
  breezy-desktop-common = pkgs.callPackage ./breezy-desktop-common.nix { };
  
  breezy-desktop-gnome = pkgs.callPackage ./breezy-desktop-gnome.nix {
    inherit breezy-desktop-common xrlinuxdriver;
  };
  
  breezy-desktop-kwin = pkgs.callPackage ./breezy-desktop-kwin.nix {
    inherit breezy-desktop-common xrlinuxdriver;
  };
in

{
  inherit xrlinuxdriver breezy-desktop-common breezy-desktop-gnome breezy-desktop-kwin;
}