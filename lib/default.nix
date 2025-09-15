# Library functions for XRLinuxDriver flake
{ lib }:

rec {
  # Creates desktop file for XR applications
  makeDesktopFile = { name, exec, icon, comment ? "" }: ''
    [Desktop Entry]
    Name=${name}
    Comment=${comment}
    Exec=${exec}
    Icon=${icon}
    Terminal=false
    Type=Application
    Categories=Utility;
  '';

  # Formats version string
  formatVersion = version: "v${version}";
  
  # Checks if a package should be built on the current system
  isSupportedSystem = system: builtins.elem system [ 
    "x86_64-linux" 
    "aarch64-linux" 
  ];
}