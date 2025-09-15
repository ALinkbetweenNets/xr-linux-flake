{ lib
, stdenv
, fetchFromGitHub
, meson
, ninja
, pkg-config
, python3
, wrapGAppsHook
, glib
, gtk3
, gnome
, gnome-shell
, librsvg
, breezy-desktop-common
, xrlinuxdriver
}:

let
  pythonEnv = python3.withPackages (ps: with ps; [
    pygobject3
    pydbus
    pyyaml
  ]);
in

stdenv.mkDerivation {
  pname = "breezy-desktop-gnome";
  version = "2.2.3";

  src = fetchFromGitHub {
    owner = "wheaney";
    repo = "breezy-desktop";
    rev = "v2.2.3";
    hash = "sha256-LYm0W6AsCo62hBLT/VLhYhK6UNxV4DkP7VT4ZzHvIlc=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    wrapGAppsHook
    pythonEnv
  ];

  buildInputs = [
    glib
    gtk3
    gnome-shell
    librsvg
    breezy-desktop-common
  ];

  # Set the environment variable to tell the build we're using GNOME
  GNOME_VERSION = "$(gnome-shell --version | cut -d' ' -f3 | cut -d'.' -f1)";

  # Determine if we're building for GNOME >= 45
  preConfigure = ''
    cd ui
    
    # Fix paths for included files
    substituteInPlace meson.build \
      --replace "join_paths('..', 'VERSION')" "'${breezy-desktop-common}/share/breezy-desktop/VERSION'"
  '';

  # Create the GNOME extension
  postBuild = ''
    cd ..
    mkdir -p $out/share/gnome-shell/extensions/breezydesktop@xronlinux.com
    cp -r gnome/src/* $out/share/gnome-shell/extensions/breezydesktop@xronlinux.com/
  '';

  postInstall = ''
    # Create setup script
    mkdir -p $out/bin
    cat > $out/bin/breezy-desktop-gnome-setup << EOF
    #!/bin/sh
    # Enable GNOME extension
    gnome-extensions enable breezydesktop@xronlinux.com
    # Start XR driver service
    systemctl --user enable --now xr-driver.service
    # Notify user to log out and back in
    echo "Please log out and back in to complete the setup."
    EOF
    chmod +x $out/bin/breezy-desktop-gnome-setup

    # Create uninstall script
    cat > $out/bin/breezy-desktop-gnome-uninstall << EOF
    #!/bin/sh
    # Disable GNOME extension
    gnome-extensions disable breezydesktop@xronlinux.com
    # Stop XR driver service
    systemctl --user disable --now xr-driver.service
    # Notify user to log out and back in
    echo "Please log out and back in to complete the uninstallation."
    EOF
    chmod +x $out/bin/breezy-desktop-gnome-uninstall
  '';

  meta = with lib; {
    description = "Breezy Desktop for GNOME - XR desktop integration";
    homepage = "https://github.com/wheaney/breezy-desktop";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = [];
  };
}