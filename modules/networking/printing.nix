{
  config,
  options,
  lib,
  ...
}:

with lib;
let
  cfg = config.anish-sevekari-modules.networking.printing;
in
{
  options.anish-sevekari-modules.networking.printing = {

    enable = mkOption {
      description = "allow network printer support";
      type = types.bool;
      default = false;
      example = true;
    };

  };

  config = mkMerge [

    (mkIf cfg.enable {
      # Enable CUPS to print documents.
      services.printing.enable = true;
      services.printing.drivers = with pkgs; [
        gutenprint
        hplip
        hplipWithPlugin
      ];
    })

  ];
}
