# Settings for logitech bluetooth devices
{
  config,
  options,
  lib,
  pkgs,
  ...
}: 

with lib;
let
  cfg = config.modules.hardware.logitech;
in {
  options.modules.hardware.logitech = {
    enable = mkOption {
      description = "enable logitech wireless devices";
      type = types.bool;
      default = false;
      example = true;
    };
  };

  config = mkIf cfg.enable {
    hardware.logitech.wireless.enable = true;
  };
}
