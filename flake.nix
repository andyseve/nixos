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
    lib = lib.utils;
    nixosConfigurations = {
      geralt = lib.nixosSystem {
        # name = "geralt";
        # wsl = false;
        # stateVersion = "23.05";
        system = "x86_64-linux";
        specialArgs = { inherit lib pkgs;};
        modules = [
          ./hardware-configuration.nix
          ./defaults.nix
          ./hosts/geralt.nix
          ./old/defaults.nix
          ./old/desktop.nix
          ./old/sound.nix
          # ./old/nvidia.nix
          ./old/security.nix
          ./old/ssh.nix
        ];
      };
    };
  };
}
