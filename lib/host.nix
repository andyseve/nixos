# Function definition to define hosts
# Reads settings from ../hosts/${hostname}.nix file to generate nixosSystem object
{
  lib,
  ...
}:
{
  # write a generic mkGenericHost function which does not rely on existing config
  mkHost = {
    name ? "geralt",
    wsl ? false,
    stateVersion ? "23.11",
    ...
  }: let
    hostConfig = (import ../hosts/${name}.nix {
      inherit name wsl stateVersion lib;
    });
  in
  lib.nixosSystem {
    system = "x86_64-linux";
    specialArgs = { inherit lib stateVersion; name = "geralt"; wsl = false; };
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
