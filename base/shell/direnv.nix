{
  config,
  hostConfig,
  lib,
  options,
  pkgs,
  ...
}:

let
	inherit (lib) mkIf;
  cfg = config.anish-sevekari-modules.shell.direnv;
in
{
  options.anish-sevekari-modules.shell.direnv = {
    enable = mkOption {
      description = "enable direnv";
      type = types.bool;
      default = false;
    };
  };

  config = mkIf cfg.enable {
    programs.direnv.enable = true;
    environment.systemPackages = [ pkgs.direnv ];
  };
}
