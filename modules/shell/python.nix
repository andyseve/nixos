{
  hostConfig,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf;
  cfg = hostConfig.shell or { };
in
{
  config = mkIf (cfg.code.python.enable or false) {
    environment.systemPackages = [
      pkgs.python3
      pkgs.uv
      pkgs.ruff
      pkgs.python3Packages.numpy
      pkgs.python3Packages.scipy
      pkgs.python3Packages.torch
      pkgs.python3Packages.matplotlib
    ];
  };
}
