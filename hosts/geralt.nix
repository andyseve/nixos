# Host information file for Geralt
{ lib, ... }:
rec {
	system = "x86_64-linux";
	wsl = true;
	hardware = {
		nvidia.enable = true;
		nvidia.type = "stable";
		audio.enable = true;
		logitech.enable = true;
	};
	networking.wifi.enable = true;
	services.ssh.enable = true;
	shell = {
		direnv.enable = true;
		utils.enable = true;
		code.cpp.enable = true;
		code.python.enable = true;
		code.haskell.enable = false;
		latex.enable = true;
	};
	env = {
		xdg = true;
		zsh = true;
	};
	users = [ "stranger" ];

	hardwareConfig = { config, lib, pkgs, ... }: {
		# Basic hardware configuration like disks, timezones, networking etc.
		# Only used when natively running on nixos
	};

	wslConfig = { config, lib, pkgs, nixos-wsl, ... }: {
		# Config options for wsl
		# only imported when running in windows subsystem for linux
	};

	darwinConfig = { config, lib, pkgs, darwin, ... }: {
		# Config options for darwin (MacOS)
		# only imported when running on MacOS using nix-darwin
	};

	# list of user modules to load along with appropriate config files.
	# userConfigs = mkUser users;
	# unfree = getUnfree users;

	unfree = hardware.nvidia.enable or hardware.logitech.enable;
}
