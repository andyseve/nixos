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
    ...
  }: let
    lib = nixpkgs.lib.extend (final: prev: {
      myutils = import ./lib {lib = final;};
    });
    pkgs = import nixpkgs {
      system = "x86_64-linux";
      config.allowUnfree = true;
      overlays = [
        (final: prev: {
          unstable = import nixpkgs-unstable {
            system = "x86_64-linux";
            config.allowUnfree = true;
          };
        })
      ];
    };
  in {
    # output local functions defined in utils
    lib = lib.myutils;

    # nixos configurations for machines
    # nixosConfigurations = {
    #   geralt = lib.nixosSystem {
    #     # name = "geralt";
    #     # wsl = false;
    #     # stateVersion = "23.05";
    #     system = "x86_64-linux";
    #     specialArgs = { inherit lib pkgs;};
    #     modules = [
    #       ./hardware-configuration.nix
    #       ./default.nix
    #       ./hosts/geralt.nix
    #       ./users/stranger.nix
    #       ./old/defaults.nix
    #       ./old/desktop.nix
    #     ];
    #   };
    # };
  };
}
