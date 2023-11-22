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
  }: let
    hostConfig = (import ../hosts/${name}.nix {
      inherit name wsl stateVersion lib inputs;
    });
  in
  lib.nixosSystem {
    system = "x86_64-linux";
    specialArgs = { inherit inputs lib stateVersion; name = "geralt"; wsl = "false"; };
    modules = [
      ../hardware-configuration.nix
      ../default.nix
      ../hosts/${name}.nix
      ../old/defaults.nix
      ../old/desktop.nix
      ../old/sound.nix
      ../old/nvidia.nix
      ../old/security.nix
      ../old/ssh.nix
    ];
  };
}
