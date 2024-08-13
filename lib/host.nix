# Function definition to define hosts
# Reads settings from ../hosts/${hostname}.nix file to generate nixosSystem object
{
  inputs,
  lib,
  pkgs,
  stateVersion,
  ...
}:
{
  # mkHost reads from hosts/${hostname}.nix file and creates a nixos config
  mkHost = {
    name ? "geralt",
    wsl ? false,
    stateVersion ? stateVersion,
    ...
  }: let
    hostConfig = (import ../hosts/${name}.nix {
      inherit name wsl stateVersion lib;
    });
  in
  lib.nixosSystem {
    system = "x86_64-linux";
    specialArgs = { inherit inputs lib stateVersion name wsl };
    modules = [
      ../hardware-configuration.nix
      ../default.nix
      ../hosts/${name}.nix
      ../old/defaults.nix
      ../old/desktop.nix
      ../old/ssh.nix
    ];
  };
}
