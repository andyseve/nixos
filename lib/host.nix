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
    inputs,
    ...
  }:
  let
    hostConfig = (import ../hosts/${name}.nix {
      inherit name wsl stateVersion inputs lib;
    });
  in
  lib.nixosSystem {
    system = hostConfig.modules.system;
    specialArgs = { inherit lib inputs; };
    modules = [
      { nixpkgs = hostConfig.nixpkgs; } 
      ../hardware-configuration.nix
      ../defaults.nix
      ../old/defaults.nix
      ../old/desktop.nix
      ../old/sound.nix
      ../old/nvidia.nix
      ../old/security.nix
      ../old/ssh.nix
    ];
  };
}
