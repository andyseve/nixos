# user settings
{ lib, hostConfig, ... }:
let
  home = if hostConfig ? home then hostConfig.home else "/home";
  username = "stranger";
  name = "Anish Sevekari";
  shell = "zsh";
in
rec {
  userConfig =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      users.users.${username} = {
        isNormalUser = true;
        home = "${home}/${username}";
        extraGroups = [ "wheel" ];
        description = name;
        createHome = true;
        shell = "${pkgs.${shell}}/bin/${shell}";
      };
    };

  homeConfig =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      home-manager.users.${username} = {
        home = {
          username = "${username}";
          homeDirectory = "${home}/${username}";
          stateVersion = "24.05";
        };
        programs.home-manager.enable = true;
      };
    };
}
