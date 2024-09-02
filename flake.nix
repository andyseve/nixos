{
  description = "NixOS config by Anish Sevekari";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      unstable,
      hyprland,
    }:
    let
      system = "x86_64-linux";
      upkgs = import unstable {
        inherit system;
        config.allowUnfree = true;
      };
    in
    rec {
      # output local functions defined in utils
      lib = unstable.lib.extend (
        final: prev: { myutils = import ./lib { lib = final; }; }
      );

      nixosConfigurations = {
        vesemir = lib.nixosSystem {
          inherit system;
          specialArgs = {
            inherit upkgs inputs;
          };
          modules = [
            ./default.nix
            ./hosts/vesemir.nix
            ./users/stranger.nix
          ];
        };
        ziraeal = lib.nixosSystem {
          inherit system;
          specialArgs = {
            inherit upkgs inputs;
          };
          modules = [
            ./default.nix
            ./hosts/ziraeal.nix
            ./users/stranger.nix
          ];
        };
      };
    };
}
