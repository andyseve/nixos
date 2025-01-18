# treefmt.nix
{ ... }:
{
  # Used to find the project root
  projectRootFile = "flake.nix";
  programs = {
    deadnix.enable = true;
    nixfmt.enable = true;
  };
  settings = {
    deadnix.priority = 1;
    nixfmt.includes = [ "*.nix" ];
    nixfmt.priority = 2;
  };
}
