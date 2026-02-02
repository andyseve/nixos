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
  config = mkIf (cfg.code.cpp.enable or false) {
    environment.systemPackages = [
      pkgs.gnumake
      pkgs.gcc
      pkgs.llvm
    ];
  };
}
