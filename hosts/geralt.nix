# Host information file
# 1. Modules - using settings from default modules
# 2. Host - function which is used in makehost to determine system settings.
# 3. Config - other customization options which are not covered my modules.
# Host config and custom settings for geralt.

{
  config,
  lib,
  pkgs,
  ...
}:
{
  modules = {
    system = "x86_64-linux";
    hardware = {
      nvidia.enable = true;
      nvidia.type = "stable";
      audio.enable = true;
      logitech.enable = true;
    };
    services = {
      ssh.enable = true;
    };
    shell = {
      direnv.enable = true;
    };
  };
}
