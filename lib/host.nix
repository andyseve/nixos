# Function definition to define hosts
# Reads settings from ../hosts/${hostname}.nix file to generate nixosSystem object
{
  lib,
  ...
}:
{
  # write a generic mkGenericHost function which does not rely on existing config
  mkHost = {
    name,
    wsl,
    stateVersion,
    lib,
    pkgs,
    ...
  }: let
    hostConfig = (import ../hosts/${name}.nix {
      inherit lib pkgs;
      config = {};
    });
    if stateVersion < min_stateVersion then return false;
    nixpkgs = inputs.nixpkgs-${stateVersion};
    pkgs = import inputs.nixpkgs-${stateVersion};
    lib = inputs.nixpkgs-${stateVersion}.lib;
  in
  lib.nixosSystem {
    system = "x86_64-linux";
    specialArgs = { inherit lib pkgs; };
    modules = [
      ../hardware-configuration.nix
      ../default.nix
      ../hosts/${name}.nix
      ../users/stranger.nix
      ../old/defaults.nix
      ../old/desktop.nix
    ];
  };
}
