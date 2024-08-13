{
  config,
  options,
  lib,
  pkgs,
  ...
}:

with lib;
with lib.myutils;
let
  modules = config.modules;
  cfg = modules.desktop;
in {
  options.modules.desktop = {

    enable = mkOption {
      description = "Enables desktop environment";
      type = types.bool;
      default = false;
      example = true;
    };

    dm.default = mkOption {
      description = "Default desktop manager";
      type = types.str;
      default = "lightdm";
      example = "lightdm";
    };

    wm.default = mkOption {
      description = "Default window manager";
      type = types.str;
      default = "xmonad";
      example = "xmonad";
    };

  };

  config = mkMerge [

    ( mkIf cfg.enable {
      modules.desktop.wm.${cfg.wm.default}.enable = true;
      modules.desktop.dm.${cfg.dm.default}.enable = true;
    })

    # ( mkIf (cfg.enable && cfg.xserver.enable) {
    #   assertions = [
    #     {
    #       # ensure that there is exactly only display manager
    #       assertion = (countAttrs (_: value: (value ? enable) && value.enable) cfg.dm) == 1;
    #       message = "Exactly one display manager should be active";
    #     }
    #     {
    #       assertion = (countAttrs (_: value: (value ? enable) && value.enable) cfg.wm) > 0;
    #       message = "At least one window manager should be active";
    #     }
    #   ];
    # })
  ];
}
