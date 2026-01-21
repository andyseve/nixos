{
  hostConfig,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf mkMerge;
  cfg = hostConfig.desktop.fonts or { };
in
{
  config = mkIf (cfg.enable or true) {
    fonts.packages = mkMerge [
      [
        pkgs.nerd-fonts.fira-code
        pkgs.nerd-fonts.caskaydia-cove
      ]
      (mkIf (cfg.marathi or true) [ pkgs.lohit-fonts.marathi ])
    ];
  };
}
