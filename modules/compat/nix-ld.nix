{
  lib,
  pkgs,
  isDarwin,
  ...
}:

lib.optionalAttrs (!isDarwin) {
  # Support prebuilt Linux binaries installed outside Nix, including VS Code
  # Remote SSH/WSL servers, Cursor servers, editor extensions, and debuggers.
  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      alsa-lib
      cairo
      cups
      curl
      dbus
      expat
      fontconfig
      freetype
      glib
      gtk3
      icu
      krb5
      libsecret
      libxcrypt
      libxml2
      nspr
      nss
      openssl
      pango
      stdenv.cc.cc.lib
      util-linux
      xorg.libX11
      xorg.libXScrnSaver
      xorg.libXcursor
      xorg.libXi
      xorg.libXrandr
      xorg.libXrender
      xorg.libXtst
      xorg.libxcb
      xorg.libxkbfile
      zlib
      zstd
    ];
  };
}
