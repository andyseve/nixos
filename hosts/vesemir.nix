# Host information file
# 1. Modules - using settings from default modules
# 2. Host - function which is used in makehost to determine system settings.
# 3. Config - other customization options which are not covered my modules.
# Host config and custom settings for geralt.

{ 
  inputs,
  config,
  lib,
  pkgs,
  ...
}: {

  networking.hostName = "vesemir";

  modules = {
    hardware = {
      audio.enable = true;
    };
    services = {
      ssh.enable = true;
    };
    shell = {
      direnv.enable = true;
    };
    desktop = {
      dm.lightdm.enable = true;
      wm.hyprland.enable = true;
    };
    env = {
      xdg = true;
      zsh = true;
    };
  };


  programs.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    xwayland.enable = true;
  };
  environment.sessionVariables.NIXOS_OZONE_WL = "1";
}

