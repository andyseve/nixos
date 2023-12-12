{
  config,
  options,
  lib,
  pkgs,
  ...
}:

with lib;
let
  cfg = config.modules.desktop.dm.lightdm;
in {
  options.modules.desktop.dm.lightdm = {
    enable = mkOption {
      description = "Enable lightdm";
      type = types.bool;
      default = false;
      example = true;
    };
  };

  config = mkIf cfg.enable {
    services.xserver.displayManager = {
      lightdm.enable = true;
    };
  };
}
