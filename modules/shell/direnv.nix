{
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
    programs.direnv.nix-direnv.enable = true; # integrate direnv with nix flakes
    environment.systemPackages = [ pkgs.direnv ];
  };
}
