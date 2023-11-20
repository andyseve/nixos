{
  description = "NixOS config by Anish Sevekari";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = {
    self,
    nixpkgs,
    nixpkgs-unstable,
    ...
  } @ inputs: let
    lib = nixpkgs.lib.extend
    (final: prev: { utils = import ./lib {lib = final;}; });
    mkHost' = {name, wsl, stateVersion}: lib.utils.host.mkHost { inherit name wsl stateVersion inputs; };
  in {
    # output local functions defined in utils
    lib = lib.utils;
    nixosConfigurations = {
      geralt = mkHost' {
        name = "geralt";
        wsl = false;
        stateVersion = "23.05";
      };
    };
  };
}
