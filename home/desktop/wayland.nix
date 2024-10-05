{
  config,
  options,
  lib,
  pkgs,
  ...
}:

with lib;
let
  modules = config.anish-sevekari-modules;
  cfg = modules.desktop.wayland;
in
{
  options.anish-sevekari-modules.desktop.wayland = {

    enable = mkOption {
      description = "Enable wayland with default options";
      type = types.bool;
      default = false;
      example = true;
    };

  };
}
