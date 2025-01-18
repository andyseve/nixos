{ options, lib, ... }:

with lib;
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
