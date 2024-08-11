{
  description = "NixOS config by Anish Sevekari";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    nixpkgs-unstable,
  }: let
    lib = nixpkgs.lib.extend (final: prev: {
      myutils = import ./lib {lib = final;};
    });
  in {
    # output local functions defined in utils
    lib = lib.myutils;

    # nixos configurations for machines
  };
}
