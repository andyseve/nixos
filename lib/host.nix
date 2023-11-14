{
  nixpkgs,
  unstable,
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
      inherit name wsl stateVersion nixpkgs unstable lib;
    };
  in
  lib.nixosSystem {
    inherit (hostConfig) system;
    inherit (hostConfig) modules;
  };
}
