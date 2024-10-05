{
  config,
  options,
  lib,
  ...
}:

with lib;
let
  cfg = config.anish-sevekari-modules.networking.wifi;
in
{
  options.anish-sevekari-modules.networking.wifi = {

    enable = mkOption {
      description = "wifi settings";
      type = types.bool;
      default = false;
      example = true;
    };

  };

  config = mkMerge [

    (mkIf cfg.enable {
      networking.wireless.iwd = {
        enable = true;
      };
    })

  ];
}
