{
	description = "NixOS config by Anish Sevekari";

	inputs = {
		nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
		unstable.url = "github:nixos/nixpkgs/nixos-unstable";
		hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
		hyprland.inputs.nixpkgs.follows = "nixpkgs";
	};

	outputs = inputs : rec {
		# output local functions defined in utils
		utils = import ./utils { lib = inputs.nixpkgs.lib; };
	};
}
