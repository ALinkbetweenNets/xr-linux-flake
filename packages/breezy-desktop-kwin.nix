{ lib
, stdenv
, fetchFromGitHub
, cmake
, extra-cmake-modules
, pkg-config
, python3
, qtbase
, qtdeclarative
, libdrm
, kconfig
, kconfigwidgets
, kcoreaddons
, kglobalaccel
, ki18n
, kcmutils
, kwindowsystem
, kxmlgui
, kwin
, breezy-desktop-common
, xrlinuxdriver
}:

let
  pythonEnv = python3.withPackages (ps: with ps; [
    pyyaml
  ]);
in

stdenv.mkDerivation {
  pname = "breezy-desktop-kwin";
  version = "2.2.3";

  src = fetchFromGitHub {
    owner = "wheaney";
    repo = "breezy-desktop";
    rev = "v2.2.3";
    hash = "sha256-LYm0W6AsCo62hBLT/VLhYhK6UNxV4DkP7VT4ZzHvIlc=";
  };

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
    pkg-config
    pythonEnv
  ];

  buildInputs = [
    qtbase
    qtdeclarative
    libdrm
    kconfig
    kconfigwidgets
    kcoreaddons
    kglobalaccel
    ki18n
    kcmutils
    kwindowsystem
    kxmlgui
    kwin
    breezy-desktop-common
  ];

  # Copy required files from other modules
  preConfigure = ''
    # Copy required files from other parts of the repo
    mkdir -p kwin/src/xrdriveripc
    cp ui/modules/PyXRLinuxDriverIPC/xrdriveripc.py kwin/src/xrdriveripc/xrdriveripc.py
    cp ${breezy-desktop-common}/share/breezy-desktop/VERSION kwin/
    cp ${breezy-desktop-common}/share/breezy-desktop/*.png kwin/src/qml/
    cp ui/data/icons/hicolor/scalable/apps/com.xronlinux.BreezyDesktop.svg kwin/src/kcm/
    
    # Move into kwin directory for build
    cd kwin
  '';

  installPhase = ''
    # Install the KWin plugin
    mkdir -p $out/lib/qt6/plugins/kwin/effects/plugins/
    install -Dm644 bin/breezyfollow.so $out/lib/qt6/plugins/kwin/effects/plugins/
    
    # Install KCM module
    mkdir -p $out/lib/qt6/plugins/plasma/kcms/
    install -Dm644 bin/kcm_breezy_kwin_follow.so $out/lib/qt6/plugins/plasma/kcms/
    
    # Install desktop files
    mkdir -p $out/share/applications/
    install -Dm644 src/kcm/kcm_breezy_kwin_follow.desktop $out/share/applications/
    install -Dm644 src/kcm/com.xronlinux.BreezyDesktop.desktop $out/share/applications/
    
    # Install icons
    mkdir -p $out/share/icons/hicolor/scalable/apps/
    install -Dm644 src/kcm/com.xronlinux.BreezyDesktop.svg $out/share/icons/hicolor/scalable/apps/
    
    # Create setup script
    mkdir -p $out/bin
    cat > $out/bin/breezy-desktop-kwin-setup << EOF
    #!/bin/sh
    # Enable KWin effect
    kwriteconfig6 --file kwinrc --group Plugins --key breezyfollowEnabled true
    # Start XR driver service
    systemctl --user enable --now xr-driver.service
    # Notify user to log out and back in
    echo "Please log out and back in to complete the setup."
    EOF
    chmod +x $out/bin/breezy-desktop-kwin-setup
    
    # Create uninstall script
    cat > $out/bin/breezy-desktop-kwin-uninstall << EOF
    #!/bin/sh
    # Disable KWin effect
    kwriteconfig6 --file kwinrc --group Plugins --key breezyfollowEnabled false
    # Stop XR driver service
    systemctl --user disable --now xr-driver.service
    # Notify user to log out and back in
    echo "Please log out and back in to complete the uninstallation."
    EOF
    chmod +x $out/bin/breezy-desktop-kwin-uninstall
  '';

  meta = with lib; {
    description = "Breezy Desktop for KDE/KWin - XR desktop integration";
    homepage = "https://github.com/wheaney/breezy-desktop";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = [];
  };
}