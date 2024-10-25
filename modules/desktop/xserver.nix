{
  config,
  hostConfig,
  isNixos,
  lib,
  ...
}:
let
  inherit (lib) mkDefault mkIf;
  cfg = hostConfig.desktop.xserver or { };
in
{
  config =
    if isNixos then
      (mkIf (cfg.enable or false) {
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
      })
    else
      { };
}
