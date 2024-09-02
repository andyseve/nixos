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
in
{
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

    services.redshift = mkDefault {
      enable = true;
      temperature.day = 6500;
      temperature.night = 3500;
    };
  };
}
