{
  config,
  options,
  lib,
  pkgs,
  ...
}:

with lib;
let
  modules = config.modules;
  cfg = modules.desktop.dm;
in {
  options.modules.desktop.dm = {

    lightdm.enable = mkOption {
      description = "Enable lightdm";
      type = types.bool;
      default = false;
      example = true;
    };

  };

  config = mkMerge [

    ( mkIf cfg.lightdm.enable {
      services.xserver.displayManager = {
        lightdm.enable = true;
      };
    })

  ];
}
