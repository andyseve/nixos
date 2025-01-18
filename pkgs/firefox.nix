{
  stdenv,
  fetchurl,
  undmg,
}:
stdenv.mkDerivation rec {
  pname = "Firefox";
  version = "132.0";

  meta = {
    description = "The Firefox Web browser";
    homepage = "https://www.mozilla.org/en-US/firefox";
    maintainers = [ "Anish Sevekari" ];
    platforms = [ "aarch64-darwin" ];
  };

  src = fetchurl {
    name = "Firefox-${version}.dmg";
    url = "http://releases.mozilla.org/pub/firefox/releases/${version}/mac/en-US/Firefox%20${version}.dmg";
    sha256 = "5924171ce774ba8d102ddb45c573ff8acd4e0c289b62597f941ca58d79289704";
  };

  buildInputs = [ undmg ];
  sourceRoot = ".";
  phases = [
    "unpackPhase"
    "installPhase"
  ];

  installPhase = ''
    mkdir -p "$out/Applications"
    cp -r Firefox.app "$out/Applications/Firefox.app"
  '';
}
