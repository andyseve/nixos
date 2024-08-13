{
  config,
  options,
  lib,
  ...
}:

with lib;
let
  cfg = config.modules.printing;
in
  options.modules.printing = {
    enable = mkOption {
      description = "allow printer support";
      type = types.bool;
      default = false;
      example = true;
    }
  }

  config = mkMerge [

    ( mkIf cfg.enable {
      # Enable CUPS to print documents.
      services.printing.enable = true;
      services.printing.drivers = with pkgs; [
        gutenprint
        hplip
        hplipWithPlugin
      ];
    })
  ]
