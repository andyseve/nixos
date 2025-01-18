{
  config,
  hostConfig,
  isDarwin,
  lib,
  pkgs,
  upkgs,
  ...
}:

let
  inherit (lib) mkMerge mkIf;
  cfg = hostConfig.desktop or { };
in
{
  config = (
    mkMerge [

      (mkIf (cfg.enable or false) {
        # modules.desktop.wm.${cfg.wm.default}.enable = true;
        # modules.desktop.dm.${cfg.dm.default}.enable = true;

        environment.systemPackages =
          [
            (if isDarwin then (pkgs.callPackage ../../pkgs/firefox.nix { }) else pkgs.firefox)
            (if isDarwin then pkgs.vlc-bin else pkgs.vlc)
            pkgs.zathura
            pkgs.kitty
          ]
          ++ [
            pkgs.vscode
          ]
          ++ [
            upkgs.discord
            upkgs.zoom-us
          ];
      })

      # ( mkIf (cfg.enable or false) {
      #   assertions = [
      #     {
      #       # ensure that there is exactly only display manager
      #       assertion = (countAttrs (_: value: (value ? enable) && value.enable) cfg.dm) == 1;
      #       message = "Exactly one display manager should be active";
      #     }
      #     {
      #       assertion = (countAttrs (_: value: (value ? enable) && value.enable) cfg.wm) > 0;
      #       message = "At least one window manager should be active";
      #     }
      #   ];
      # })
    ]
  );
}
