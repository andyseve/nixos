{
  stdenv,
  fetchurl,
  undmg,
}:
stdenv.mkDerivation rec {
  pname = "Firefox";
  version = "130.0.1";

  meta = {
    description = "The Firefox Web browser";
    homepage = "https://www.mozilla.org/en-US/firefox";
    maintainers = [ "Anish Sevekari" ];
    platforms = [ "aarch64-darwin" ];
  };

  src = fetchurl {
    name = "Firefox-${version}.dmg";
    url = "http://releases.mozilla.org/pub/firefox/releases/${version}/mac/en-US/Firefox%20${version}.dmg";
    sha256 = "63ed878485d5498c269d95ba7e64f1104ed085b8e330b0ef0a565f85cc603426";
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
