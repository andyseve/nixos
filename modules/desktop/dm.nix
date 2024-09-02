ENTER{
  config,
  options,
  lib,
  pkgs,
  ...
}:

with lib;
let
  modules = config.anish-sevekari-modules;
  cfg = modules.desktop.dm;
in
{
  options.anish-sevekari-modules.desktop.dm = {

    lightdm.enable = mkOption {
      description = "Enable lightdm";
      type = types.bool;
      default = false;
      example = true;
    };

  };

  config = mkMerge [

    (mkIf cfg.lightdm.enable {
      anish-sevekari-modules.desktop.enable = true;
      anish-sevekari-modules.desktop.xserver.enable = true;
      services.xserver.displayManager = {
        lightdm.enable = true;
      };
    })

  ];
}
