{ config, options, lib, pkgs, ... }:

with lib;
let
  cfg = config.modules.shell.direnv;
in
{
  options.modules.shell.direnv = {
    enable = mkOption {
      description = "enable direnv";
      type = types.bool;
      default = false;
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = mkMerge [ pkgs.direnv ];
  };
}
