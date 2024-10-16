{
  inputs,
  config,
  options,
  lib,
  pkgs,
  ...
}:

with lib;
let
  modules = config.anish-sevekari-modules;
  cfg = modules.desktop.wm;
in
{
  options.anish-sevekari-modules.desktop.wm = {

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

    (mkIf cfg.xmonad.enable {
      anish-sevekari-modules.desktop.enable = true;
      anish-sevekari-modules.desktop.xserver.enable = true;

      services = mkDefault {
        xserver = {
          windowManager.xmonad = {
            enable = true;
            enableContribAndExtras = true;
            extraPackages = haskellPackages: [
              haskellPackages.xmonad-contrib
              haskellPackages.xmonad-extras
              haskellPackages.xmonad
            ];
          };
        };

      };

      environment.systemPackages = with pkgs; [
        xmobar # need a bar for xmonad
        feh # pictures
        dunst
        libnotify # notifications
        rofi
        xdotool # xserver scripting
        xorg.xmodmap
        xorg.xrandr
        xorg.libXinerama # xserver scripting
      ];
    })

    (mkIf cfg.hyprland.enable {
      anish-sevekari-modules.desktop.enable = true;
      anish-sevekari-modules.desktop.wayland.enable = true;

      programs.hyprland = {
        enable = true;
        package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
        xwayland.enable = true;
      };
      environment.sessionVariables.NIXOS_OZONE_WL = "1";

      environment.systemPackages = [
        pkgs.waybar
        pkgs.dunst
        pkgs.libnotify
        pkgs.rofi-wayland
      ];
    })

  ];
}
