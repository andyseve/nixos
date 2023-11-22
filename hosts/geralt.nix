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
}: {
  modules = {
    shell = {
      direnv.enable = true;
    };
    hardware = {
      nvidia.enable = true;
      nvidia.type = "stable";
      audio.enable = true;
    };
    desktop = {
      fonts.enable = true;
    }
  };
}

