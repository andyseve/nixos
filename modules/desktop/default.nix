{
  config,
  options,
  lib,
  pkgs,
  ...
}:

with lib;
let
  cfg = config.modules.desktop;
in {
  options.modules.desktop = {
    enable = mkOption {
      description = "Enables desktop environment with default options";
      type = types.bool;
      default = false;
      example = true;
    };
    picom.enable = mkOption {
      description = "Enable picom compositor";
      type = types.bool;
      default = false;
      example = true;
    };
    redshift.enable = mkOption {
      description = "Enable redshift to change colors during day and night";
      type = types.bool;
      default = false;
      example = true;
    };
  };

  config = mkMerge [
    ( mkIf cfg.picom.enable {
      services.picom = {
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
    })
    ( mkIf cfg.redshift.enable {
      services.redshift = {
        enable = true;
        temperature.day = 6500;
        temperature.night = 3500;
      };
    })
    ( mkIf cfg.enable {
      assertions = [
        {
          # ensure that there is exactly only display manager
          assertion = (countAttrs (name: value: n == "enable" && value) cfg.dm) == 1;
          message = "Exactly one display manager should be active";
        }
        {
          assertion = (countAttrs (name: value: n == "enable" && value) cfg.wm) > 0;
          message = "At least one window manager should be active";
        }
      ];
      modules.desktop = {
        xserver.enable = true;
        dm.lightdm.enable = true;
        wm.xmonad.enable = true;

        picom.enable = true;
        redshift.enable = true;
      };
    })
  ];
}
