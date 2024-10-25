{
  config,
  hostConfig,
  isNixos,
  lib,
  ...
}:

let
  inherit (lib) mkIf mkMerge;
  cfg = hostConfig.desktop.dm or { };
in
{
  config =
    if isNixos then
      (mkMerge [

        (mkIf (cfg.lightdm.enable or false) {
          assertions = [
            { assertion = hostConfig.desktop.enable; }
            { assertion = hostConfig.desktop.xserver.enable; }
          ];
          services.xserver.displayManager = {
            lightdm.enable = true;
          };
        })

      ])
    else
      { };
}
