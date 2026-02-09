# user settings
{ hostConfig, ... }:
rec {
  home = if hostConfig ? home then hostConfig.home else "/home";
  username = "stranger";
  name = "Anish Sevekari";
  shell = "zsh";
  userConfig =
    {
      pkgs,
      isDarwin,
      isNixos,
      hostConfig,
      ...
    }:
    {
      users.users.${username} = {
        description = name;
        shell = "${pkgs.${shell}}/bin/${shell}";
        home = if isDarwin then "/Users/${username}" else "${home}/${username}";
        packages = [ pkgs.home-manager ];
      }
      // (
        if isNixos then
          {
            isNormalUser = true;
            extraGroups = [ "wheel" ];
            createHome = true;
          }
          else
          { }
      )
      // (
        if (hostConfig.shell.docker.enable or false) then
          {
            extraGroups = [ "docker" ];
          }
        else
          { }
      );
    };

  home-managerModule = false;

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
