{
  description = "NixOS config by Anish Sevekari";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.05";
    unstable.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = inputs @ {self, nixpkgs, unstable}:
  let
    x = nixpkgs.lib.debug.traceValSeq nixpkgs;
    lib = nixpkgs.lib.extend
      (final: prev: { utils = import ./lib {lib = final;}; });
    mkHost' = {name, wsl, stateVersion}: lib.utils.host.mkHost { inherit name wsl stateVersion; inputs = lib.debug.traceValSeq inputs; };
  in {
    utils = lib.utils;
    nixosConfigurations = {
      geralt = mkHost' {
        name = "geralt";
        wsl = false;
        stateVersion = "23.05";
      };
    };
  };
}
