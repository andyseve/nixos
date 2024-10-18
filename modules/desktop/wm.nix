{
  config,
  hostConfig,
  hyprland,
  isNixos,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib) mkDefault mkIf mkMerge;
  cfg = hostConfig.desktop.wm or {};
in
{
  config = mkIf isNixos (mkMerge [

    (mkIf (cfg.xmonad.enable or false) {
      assertions = [
      { assertion = hostConfig.desktop.enable; }
	{ assertion = hostConfig.desktop.xserver.enable; }
	];

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

      environment.systemPackages = [
        pkgs.xmobar # need a bar for xmonad
        pkgs.feh # pictures
        pkgs.dunst
        pkgs.libnotify # notifications
        pkgs.rofi
        pkgs.xdotool # xserver scripting
        pkgs.xorg.xmodmap
        pkgs.xorg.xrandr
        pkgs.xorg.libXinerama # xserver scripting
      ];
    })

    (mkIf (cfg.hyprland.enable or false) {
      assertions = [
      { assertion = hostConfig.desktop.enable; }
	{ assertion = hostConfig.desktop.wayland.enable; }
	];

      programs.hyprland = {
        enable = true;
        package = hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
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

  ]);
}
