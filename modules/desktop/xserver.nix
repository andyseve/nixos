{
  config,
  options,
  lib,
  pkgs,
  ...
}:

with lib;
let
  cfg = config.modules.desktop.xserver;
in {
  options.modules.desktop.xserver = {
    enable = mkOption {
      description = "Enable xserver with default options";
      type = types.bool;
      default = false;
      example = true;
    };
  };

  config = mkIf cfg.enable {
    services.xserver.enable = true;
  };
}
