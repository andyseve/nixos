{
  description = "NixOS config by Anish Sevekari";

  inputs = {
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-23-05.url = "github:nixos/nixpkgs/nixos-23.05";
    nixpkgs-22-11.url = "github:nixos/nixpkgs/nixos-22.11";
  };

  outputs = {
    self,
    nixpkgs,
    nixpkgs-unstable,
    ...
  } @ inputs: let
    myutils = import ./lib { lib = nixpkgs-unstable.lib; };
    inherit (myutils) host modules;
    lib = nixpkgs.lib.extend (final: prev: {
      utils = import ./lib {lib = final;};
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
    lib = myutils;

    # nixos configurations for machines
    nixosConfigurations = {
      geralt = host.mkHost {
        inherit inputs;
        name = "geralt";
        wsl = false;
        stateVersion = "23.05";
      };
      # geralt = lib.nixosSystem {
      #   # name = "geralt";
      #   # wsl = false;
      #   # stateVersion = "23.05";
      #   system = "x86_64-linux";
      #   specialArgs = { inherit lib pkgs; };
      #   modules = [
      #     ./hardware-configuration.nix
      #     ./default.nix
      #     ./hosts/geralt.nix
      #     ./users/stranger.nix
      #     ./old/defaults.nix
      #     ./old/desktop.nix
      #     ./old/ssh.nix
      #   ];
      # };
    };
  };
}
