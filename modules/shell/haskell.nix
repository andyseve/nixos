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
  config = mkIf (cfg.code.haskell.enable or false) {
    environment.systemPackages = [
      pkgs.haskellPackages.ghc
      pkgs.haskellPackages.hoogle
    ];
  };
}
