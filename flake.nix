{
  description = "NixOS config by Anish Sevekari";

  inputs = {
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    nixpkgs-unstable,
  }:
  # }: let
  #   lib = nixpkgs.lib.extend (final: prev: {
  #     myutils = import ./lib {lib = final;};
  #   });
  rec {
    # output local functions defined in utils
    lib = nixpkgs-unstable.lib.extend (final: prev: {
      myutils = import ./lib {lib = final;};
    });
  };
}
