{
  description = "NixOS config by Anish Sevekari";

  nixConfig = {
    extra-experimental-features = "nix-command flakes";
    extra-substituters = "https://cache.nixos.org https://nix-community.cachix.org https://cuda-maintainers.cachix.org https://hyprland.cachix.org";
    trusted-public-keys = "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY= nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs= cuda-maintainers.cachix.org-1:0dq3bujKpuEPMCX6U4WylrUDZ9JyUG0VpVZa7CNfq5E= hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=";
  };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    # use lix
    lix.url = "https://git.lix.systems/lix-project/nixos-module/archive/2.92.0-2.tar.gz";
    lix.inputs.nixpkgs.follows = "nixpkgs";

    # Controls system level settings for MacOS
    darwin.url = "github:lnl7/nix-darwin/nix-darwin-24.11";
    darwin.inputs.nixpkgs.follows = "nixpkgs";

    # Controls homebrew installation
    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";
    nix-homebrew.inputs.nixpkgs.follows = "nixpkgs";
    nix-homebrew.inputs.nix-darwin.follows = "darwin";

    # Modules for wsl
    nixos-wsl.url = "github:nix-community/nixos-wsl";
    nixos-wsl.inputs.nixpkgs.follows = "nixpkgs";

    # Manages configs and home directory
    home-manager.url = "github:nix-community/home-manager/release-24.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # HYPRLAND desktop manager for wayland
    hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
    hyprland.inputs.nixpkgs.follows = "nixpkgs";

    # treefmt to format files
    treefmt-nix.url = "github:numtide/treefmt-nix";
    treefmt-nix.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs: rec {
    # output local functions defined in utils
    utils = import ./utils { lib = inputs.nixpkgs.lib; };
    hostnames = utils.fileNames (toString ./hosts);
    usernames = utils.fileNames (toString ./users);
    hostConfigs = builtins.listToAttrs (
      builtins.map (name: {
        name = name;
        value = import ./hosts/${name}.nix { };
      }) hostnames
    );
    systems = [
      "x86_64-linux"
      "aarch64-darwin"
    ];
    nixosConfigurations = inputs.nixpkgs.lib.foldlAttrs (utils.mkHostNixos inputs) { } (
      inputs.nixpkgs.lib.mapAttrs (name: _value: utils.mkHost name) hostConfigs
    );
    darwinConfigurations = inputs.nixpkgs.lib.foldlAttrs (utils.mkHostDarwin inputs) { } (
      inputs.nixpkgs.lib.mapAttrs (name: _value: utils.mkHost name) hostConfigs
    );
    formatter = builtins.listToAttrs (
      builtins.map (system: {
        name = system;
        value =
          (inputs.treefmt-nix.lib.evalModule (inputs.nixpkgs.legacyPackages.${system}) ./.treefmt.nix)
          .config.build.wrapper;
        # value = inputs.nixpkgs.legacyPackages.${system}.treefmt;
      }) systems
    );
  };
}
