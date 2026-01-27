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
    programs.direnv = {
      enable = true;
      nix-direnv = {
        enable = true; # integrate direnv with nix flakes and keep GC roots
        package = pkgs.nix-direnv;
      };
    };
    environment.systemPackages = [ pkgs.direnv ];
  };
}
