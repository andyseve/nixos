{
	description = "NixOS config by Anish Sevekari";

	inputs = {
		nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
		unstable.url = "github:nixos/nixpkgs/nixos-unstable";

		# Manages configs and home directory
		home-manager.url = "github:nix-community/home-manager/release-24.05";
		home-manager.inputs.nixpkgs.follows = "nixpkgs";

		# Controls system level settings for MacOS
		darwin.url = "github:lnl7/nix-darwin";
		darwin.inputs.nixpkgs.follows = "nixpkgs";

		# Modules for wsl
		nixos-wsl.url = "github:nix-community/nixos-wsl";
		nixos-wsl.inputs.nixpkgs.follows = "nixpkgs";

		# HYPRLAND desktop manager for wayland
		hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
		hyprland.inputs.nixpkgs.follows = "nixpkgs";
	};

	outputs = inputs : let
		utils = import ./utils { lib = inputs.nixpkgs.lib; };
		wsl = inputs.nixpkgs.lib.traceVal utils.isWSL;
	in
	rec {
		# output local functions defined in utils
		utils = import ./utils { lib = inputs.nixpkgs.lib; };
		formatter = inputs.nixpkgs.legacyPackages.${builtins.currentSystem}.nixpkgs-fmt;
		hostnames = utils.fileNames (toString ./hosts);
		usernames = utils.fileNames (toString ./users);
		hosts = inputs.nixpkgs.lib.mapAttrs (name: value: utils.mkHost name) hostnames;
		nixosConfigurations = inputs.nixpkgs.lib.foldlAttrs (utils.mkHostNixos inputs) {} hosts;
	};
}
