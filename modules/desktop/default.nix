{
  config,
  options,
  lib,
  pkgs,
  ...
}:

with lib;
let
  cfg = config.modules.desktop;
in {
  options.modules.desktop = {
    enable = mkOption {
      description = "Enables desktop environment with default options";
      type = types.bool;
      default = false;
      example = true;
    };
  };

  config = mkIf cfg.enable {
    modules.desktop = {
      xserver.enable = true;
      dm.lightdm.enable = true;
      wm.xmonad.enable = true;
      
      picom.enable = true;
      redshift.enable = true;
    };
  };
}
