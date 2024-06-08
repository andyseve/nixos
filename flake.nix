{
  description = "NixOS config by Anish Sevekari";

  inputs = {
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    nixpkgs-unstable,
    ...
  }: let
    stateVersion = 23.11;
    nixpkgs = builtins.getFlake "github:nixos/nixpkgs/nixos-23.11";
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
    geralt = import ./hosts/geralt.nix {lib = nixpkgs-unstable.lib; config = nixpkgs-unstable.config; pkgs = pkgs;};
  in rec {
    lib = nixpkgs-unstable.lib.extend (final: prev: {
      myutils = import ./lib {lib = final;};
    });

    host = lib.debug.traceValSeq geralt.modules;
    system = lib.debug.traceValSeq host.system;

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
