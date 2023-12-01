{
  config,
  options,
  lib,
  pkgs,
  ...
}:

with lib;
let
  cfg = config.modules.desktop.xmonad;
in {
  options.modules.desktop.xmonad = {
    enable  = mkOption {
      description = "enable xmonad";
      type = "types.bool";
      default = false;
      example = true;
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      xmobar # need a bar for xmonad
      feh # pictures
      dunst libnotify # notifications
      xdotool # xserver scripting
      xorg.xmodmap xorg.xrandr xorg.libXinerama # xserver scripting

      playerctl # control music in browsers from keyboard
    ];
    services = {
      picom.enable = true;
      redshift = {
        enable = true;
        temprature.day = 6500;
        temprature.night = 3500;
      };
      xserver = {
        enable = true;
        displayManager = {
          defaultSession = "none+xmonad";
          lightdm.enable = true;
        };
        windowManager.xmonad = {
          enable = true;
          enableContribAndExtras = true;
          extraPackages = haskellPackages : [
            haskellPackages.xmonad-contrib
            haskellPackages.xmonad-extras
            haskellPackages.xmonad
          ];
        };
      };
    };
  };
}
