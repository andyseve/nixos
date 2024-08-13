{
  config,
  options,
  lib,
  pkgs,
  ...
}:

with lib;
let
  modules = config.modules;
  cfg = modules.desktop.wm;
in {
  options.modules.desktop.wm = {

    xmonad.enable = mkOption {
      description = "enable xmonad";
      type = types.bool;
      default = false;
      example = true;
    };

    hyprland.enable = mkOption {
      description = "enable hyprland";
      type = types.bool;
      default = false;
      example = true;
    };

  };

  config = mkMerge [

    ( mkIf cfg.xmonad.enable {
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
      environment.systemPackages = with pkgs; [
        xmobar  # need a bar for xmonad
        feh # pictures
        dunst libnotify # notifications
        rofi
        xdotool # xserver scripting
        xorg.xmodmap xorg.xrandr xorg.libXinerama # xserver scripting
        playerctl # control music in browsers from keyboard
      ];
    })

    ( mkIf cfg.hyprland.enable {
      programs.hyprland = {
        enable = true;
        package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
        xwayland.enable = true;
      };
      environment.sessionVariables.NIXOS_OZONE_WL = "1";
    })

  ];
}
