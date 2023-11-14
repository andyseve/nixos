{
  description = "NixOS config by Anish Sevekari";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.05";
    unstable.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = {self, nixpkgs, unstable}@inputs:
  let
    lib = nixpkgs.lib;
    utils = import ./lib {
      inherit nixpkgs unstable lib;
    };
    inherit (utils) host;
  in {
    nixosConfigurations = {
      geralt = host.mkHost {
        name = "geralt";
        wsl = false;
        stateVersion = "23.05";
      };
    };
  };
}
