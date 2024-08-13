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
      services = mkDefault {
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

        picom = {
          enable = true;
          backend = "glx";
          vSync = true;
          settings = {

            # Unredirect all windows if a full-screen opaque window is detected, to
            # maximize performance for full-screen windows. Known to cause
            # flickering when redirecting/unredirecting windows.
            unredir-if-possible = true;

            # GLX backend: Avoid using stencil buffer, useful if you don't have a
            # stencil buffer. Might cause incorrect opacity when rendering
            # transparent content (but never practically happened) and may not work
            # with blur-background. My tests show a 15% performance boost.
            # Recommended.
            glx-no-stencil = true;

            # Use X Sync fence to sync clients' draw calls, to make sure all draw
            # calls are finished before picom starts drawing. Needed on
            # nvidia-drivers with GLX backend for some users.
            xrender-sync-fence = true;

          };
        };

        redshift = mkDefault {
          enable = true;
          temperature.day = 6500;
          temperature.night = 3500;
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
