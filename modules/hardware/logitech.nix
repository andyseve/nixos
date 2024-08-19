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
  cfg = config.anish-sevekari-modules.hardware.logitech;
in
{
  options.anish-sevekari-modules.hardware.logitech = {
    enable = mkOption {
      description = "enable logitech wireless devices";
      type = types.bool;
      default = false;
      example = true;
    };
  };

  config = mkIf cfg.enable { hardware.logitech.wireless.enable = true; };
}
