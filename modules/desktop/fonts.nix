{
  config,
  hostConfig,
  lib,
  pkgs,
  ...
}:
let
	inherit (lib) mkIf mkMerge;
  modules = config.anish-sevekari-modules;
  cfg = hostConfig.desktop.fonts or {};
in
{
  config = mkIf (cfg.enable or true) {
    fonts = {
      packages =
        with pkgs;
        mkMerge [
          [
            (nerdfonts.override {
              fonts = [
                "FiraCode"
                "FiraMono"
                "CascadiaCode"
              ];
            })
          ]
          (mkIf (cfg.marathi or true) [ lohit-fonts.marathi ])
        ];
    };
  };
}
