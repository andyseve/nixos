{
  config,
  hostConfig,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib) mkIf;
  cfg = hostConfig.shell.direnv or { };
in
{
  config = mkIf (cfg.enable or false) {
    programs.direnv.enable = true;
    environment.systemPackages = [ pkgs.direnv ];
  };
}
