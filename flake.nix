{
  description = "NixOS config by Anish Sevekari";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.05";
    unstable.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = inputs @ {self, nixpkgs, unstable}:
  let
    lib = nixpkgs.lib;
    utils = import ./lib {
      inherit inputs lib;
    };
    inherit (utils) host;
  in {
    # nixpkgs.overlays = {
    #   channels = (
    #     final: prev: {
    #       unstable = import inputs.unstable { system = final.system; config = final.config; };
    #     }
    #   );
    # };
    nixosConfigurations = {
      geralt = host.mkHost {
        name = "geralt";
        wsl = false;
        stateVersion = "23.05";
      };
    };
  };
}
