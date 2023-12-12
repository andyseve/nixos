{
  config,
  options,
  lib,
  pkgs,
  ...
}:

with lib;
let
  cfg = config.modules.desktop.fonts;
in {
  options.modules.desktop.fonts = {
    enable = mkOption {
      description = "enable fonts";
      type = types.bool;
      default = false;
      example = true;
    };

    marathi = mkOption {
      description = "enable fonts";
      type = types.bool;
      default = false;
      example = true;
    };
  };

  config = mkIf cfg.enable {
    fonts = {
      fonts = with pkgs; mkMerge [
        [
          noto-fonts noto-fonts-cjk noto-fonts-emoji
          fira-code cascadia-code
          (nerdfonts.override { fonts = [ "FiraCode" "FiraMono" "CascadiaCode" ]; })
        ]
        (mkIf cfg.marathi [ lohit-fonts.marathi ])
      ];
    };
  };
}
