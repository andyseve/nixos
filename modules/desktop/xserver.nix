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
  cfg = modules.desktop.xserver;
in {
  options.modules.desktop.xserver = {

    enable = mkOption {
      description = "Enable xserver with default options";
      type = types.bool;
      default = modules.desktop.enable;
      example = true;
    };

  };

  config = mkIf cfg.enable {
    services.xserver.enable = true;
  };
}
