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
  cfg = modules.desktop.xserver;
in {
  options.anish-sevekari-modules.desktop.xserver = {

    enable = mkOption {
      description = "Enable xserver with default options";
      type = types.bool;
      default = false;
      example = true;
    };

  };

  config = mkIf cfg.enable {
    services.xserver = {
      enable = true;
      layout = "us";
      # xkbOptions = "eurosign:e"

      libinput = {
        enable = true;
        touchpad = {
          accelProfile = "flat";
          disableWhileTyping = true;
        };
      };
      wacom.enable = true;
    };
  };
}
