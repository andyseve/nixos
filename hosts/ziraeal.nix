# Host information file for ziraeal
{ lib, ... }:
rec {
  system = "aarch64-darwin";
  darwin = true;
  hardware = {
    audio.enable = true;
  };
  networking = {
    wifi.enable = true;
  };
  services = {
    ssh.enable = true;
  };
  shell = {
    direnv.enable = true;
    utils.enable = true;
    code.cpp.enable = true;
    code.python.enable = true;
    code.haskell.enable = false;
    latex.enable = true;
  };
  desktop = {
    enable = true;
    wm.hyprland.enable = true;
  };
  env = {
    xdg = true;
    zsh = true;
  };
  users = [ "stranger" ];

  darwinConfig =
    {
      config,
      lib,
      pkgs,
      darwin,
      ...
    }:
    {
      # Config options for darwin (MacOS)
      # only imported when running on MacOS using nix-darwin
			networking.computerName = "ziraeal";
			networking.hostName = "ziraeal";
			environment.shells = [ pkgs.bashInteractive pkgs.zsh ];
			system.defaults = {
				finder.AppleShowAllExtensions = true;
				NSGlobalDomain = {
					AppleShowAllExtensions = false;
					InitialKeyRepeat = 10;
					KeyRepeat = 1;
				};
			};
    };
}
