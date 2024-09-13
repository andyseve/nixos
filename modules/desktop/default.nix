{
  inputs,
  config,
  options,
  lib,
  pkgs,
  upkgs,
  ...
}:

with lib;
with lib.myutils;
let
  modules = config.anish-sevekari-modules;
  cfg = modules.desktop;
in
{
  options.anish-sevekari-modules.desktop = {

    enable = mkOption {
      description = "Enables desktop environment";
      type = types.bool;
      default = false;
      example = true;
    };

    # dm.default = mkOption {
    #   description = "Default desktop manager";
    #   type = types.str;
    #   default = "";
    #   example = "lightdm";
    # };
    #
    # wm.default = mkOption {
    #   description = "Default window manager";
    #   type = types.str;
    #   default = "";
    #   example = "xmonad";
    # };

  };

  config = mkMerge [

    (mkIf cfg.enable {
      # modules.desktop.wm.${cfg.wm.default}.enable = true;
      # modules.desktop.dm.${cfg.dm.default}.enable = true;

      environment.systemPackages =
        [
          pkgs.firefox
          pkgs.vlc
          pkgs.zathura
          pkgs.kitty
        ]
        ++ [
          pkgs.vscode
          (pkgs.vscode-with-extensions.override{
            vscodeExtensions = with pkgs.vscode-extensions; [
              jnoortheen.nix-ide
              ms-python.python
              ms-pyright.pyright
              ms-python.flake8
              ms-vscode.cpptools
              ms-vscode-remote.remote-ssh
              github.copilot
            ];
          })
        ]
        ++ [
          upkgs.zoom-us
          upkgs.slack
          upkgs.discord
        ]
        ++ [
          pkgs.streamlink
          pkgs.playerctl
        ];
    })

    # ( mkIf (cfg.enable && cfg.xserver.enable) {
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
  ];
}
