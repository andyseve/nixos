{
  config,
  options,
  lib,
  pkgs,
  ...
}:

with lib;
let
  modules = config.anish-sevekari-modules;
  cfg = modules.desktop.fonts;
in
{
  options.anish-sevekari-modules.desktop.fonts = {

    enable = mkOption {
      description = "enable fonts";
      type = types.bool;
      default = modules.desktop.enable;
      example = true;
    };

    marathi = mkOption {
      description = "enable fonts";
      type = types.bool;
      default = cfg.enable;
      example = true;
    };

  };

  config = mkIf cfg.enable {
    fonts = {
      packages =
        with pkgs;
        mkMerge [
          [
            noto-fonts
            noto-fonts-cjk
            noto-fonts-emoji
            fira-code
            cascadia-code
            (nerdfonts.override {
              fonts = [
                "FiraCode"
                "FiraMono"
                "CascadiaCode"
              ];
            })
          ]
          (mkIf cfg.marathi [ lohit-fonts.marathi ])
        ];
    };
  };
}
