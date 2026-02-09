# user settings
{ hostConfig, lib, ... }:
rec {
  home = if hostConfig ? home then hostConfig.home else "/home";
  username = "stranger";
  name = "Anish Sevekari";
  shell = "zsh";
  userConfig =
    {
      pkgs,
      isDarwin,
      isNixos ? false,
      hostConfig,
      ...
    }:
    lib.mkMerge [
      {
        users.users.${username} = {
          description = name;
          shell = "${pkgs.${shell}}/bin/${shell}";
          home = if isDarwin then "/Users/${username}" else "${home}/${username}";
          packages = [ pkgs.home-manager ];
        };
      }
      (lib.mkIf isNixos {
        users.users.${username} = {
          isNormalUser = true;
          extraGroups = [ "wheel" ];
          createHome = true;
        };
      })
      (lib.mkIf (hostConfig.shell.docker.enable or false) {
        users.users.${username} = {
          extraGroups = [ "docker" ];
        };
      })
    ];
  home-manager-module = false;

  homeConfig =
    { isDarwin, ... }:
    {
      home-manager.users.${username} = {
        home = {
          inherit username;
          homeDirectory = if isDarwin then "/Users/${username}" else "${home}/${username}";
          stateVersion = "24.11";
        };
        programs.home-manager.enable = true;
        programs.zsh.enable = true;
      };
    };
}
