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
  config = mkIf (cfg.latex.enable or false) {
    environment.systemPackages = [
      pkgs.texliveFull
      pkgs.texlivePackages.biber
      pkgs.texlivePackages.git-latexdiff
      pkgs.texlivePackages.latexdiff
    ];
  };
}
