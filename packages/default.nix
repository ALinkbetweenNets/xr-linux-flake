{
  pkgs,
  xrealInterfaceLibrary,
  upstream,
  system,
  ...
}:

{
  xrlinuxdriver = pkgs.callPackage ./xrlinuxdriver.nix {
    inherit xrealInterfaceLibrary upstream system;
  };
}