# Function definition to define hosts
# Reads settings from ../hosts/${hostname}.nix file to generate nixosSystem object
{
  inputs,
  lib,
  ...
}:
{
  # write a generic mkGenericHost function which does not rely on existing config
  mkHost = {
    name,
    wsl,
    stateVersion,
    ...
  }:
  let
    hostConfig = import ../hosts/${name}.nix {
      inherit name wsl stateVersion inputs lib;
    };
  in
  lib.nixosSystem {
    system = hostConfig.sys;
    modules = [
      {
        nixpkgs =  {
          system = "x86_64-linux";
          config.allowUnfree = true;
          overlays = [
            ( final: prev: {
              unstable = import inputs.nixpkgs-unstable {
                system = "x86_64-linux";
                config.allowUnfree = true;
              };
            })
          ];
        };
      }
      ../hardware-configuration.nix
      ../defaults.nix
      ../modules/defaults.nix
    ];
  };
}
