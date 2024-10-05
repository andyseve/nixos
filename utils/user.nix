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
      userConfig.userConfig
      userConfig.homeConfig
    ];
}
