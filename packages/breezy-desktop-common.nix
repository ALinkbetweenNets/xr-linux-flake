{ lib
, stdenv
, fetchFromGitHub
}:

stdenv.mkDerivation {
  pname = "breezy-desktop-common";
  version = "2.2.3";

  src = fetchFromGitHub {
    owner = "wheaney";
    repo = "breezy-desktop";
    rev = "v2.2.3";
    hash = "sha256-LYm0W6AsCo62hBLT/VLhYhK6UNxV4DkP7VT4ZzHvIlc=";
  };

  dontBuild = true;
  dontConfigure = true;

  installPhase = ''
    mkdir -p $out/share/breezy-desktop
    cp -r VERSION $out/share/breezy-desktop/
    cp -r modules/sombrero/*.png $out/share/breezy-desktop/
    cp -r ui/data/icons $out/share/icons
  '';

  meta = with lib; {
    description = "Common files for Breezy Desktop";
    homepage = "https://github.com/wheaney/breezy-desktop";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = [];
  };
}