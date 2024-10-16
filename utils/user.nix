# Function definition to define users
# Reads settings from ../users/${username}.nix file to generate a nixos module
{ lib, ... }:
{
  mkUser =
    hostConfig: username:
    let
      userConfig = import ../users/${username}.nix { inherit lib hostConfig; };
      mkDefaultUserConfig =
        userConfig:
        {
          isDarwin,
          isNixos,
          pkgs,
          ...
        }:
        {
          users.users.${userConfig.username} =
            {
              description = userConfig.name;
              shell = pkgs.${userConfig.shell};
              home =
                if isDarwin then "/Users/${userConfig.username}" else "${userConfig.home}/${userConfig.username}";
              packages = [ pkgs.home-manager ];
            }
            // (
              if isNixos then
                {
                  isNormalUser = true;
                  extraGroups = [ "wheel" ];
                }
              else
                { }
            );
        };
    in
    [
      (if userConfig ? userConfig then userConfig.userConfig else mkDefaultUserConfig userConfig)
      (
        if
          (userConfig ? homeConfig && userConfig ? home-manager-module && userConfig.home-manager-module)
        then
          userConfig.homeConfig
        else
          { }
      )
    ];
}
