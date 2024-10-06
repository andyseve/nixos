# Function definition to define users
# Reads settings from ../users/${username}.nix file to generate a nixos module
{ lib, ... }:
{
  mkUser =
    hostConfig: username:
    let
      userConfig = import ../users/${username}.nix { inherit lib hostConfig; };
    in
    [
      (if userConfig?userConfig then userConfig.userConfig else { config, isDarwin, isNixos, lib, pkgs, ... }: {
				users.users.${username} = {
					description = userConfig.name;
					shell = pkgs.${userConfig.shell};
					home = if isDarwin then "/Users/${username}" else "${userConfig.home}/${username}";
				} // (if isNixos then {
					isNormalUser = true;
					extraGroups = [ "wheel" ];
				} else {});
			})
      (if userConfig?homeConfig then userConfig.homeConfig else { config, isDarwin, ... }: {
				home-manager.users.${username} = {
					home = {
						inherit username;
						homeDirectory = if isDarwin then "/Users/${username}" else "${userConfig.home}/${username}";
						stateVersion = "24.05";
					};
					programs.home-manager.enable = true;
				};
			})
    ];
}
