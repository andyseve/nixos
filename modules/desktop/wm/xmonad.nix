{
  config,
  options,
  lib,
  pkgs,
  ...
}:

with lib;
let
  cfg = config.modules.desktop.wm.xmonad;
in {
  options.modules.desktop.wm.xmonad = {
    enable  = mkOption {
      description = "enable xmonad";
      type = types.bool;
      default = false;
      example = true;
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      xmobar  # need a bar for xmonad
      feh # pictures
      dunst libnotify # notifications
      xdotool # xserver scripting
      xorg.xmodmap xorg.xrandr xorg.libXinerama # xserver scripting

      playerctl # control music in browsers from keyboard
    ];
    services = {
      xserver = {
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
