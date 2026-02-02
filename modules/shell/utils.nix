{
  hostConfig,
  isDarwin,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf;
  cfg = hostConfig.shell or { };
in
{
  config = mkIf (cfg.utils.enable or false) {
    environment.systemPackages = [
      pkgs.git
    ] # Version Control
    ++ [
      pkgs.zip
      pkgs.unzip
    ] # archives
    ++ [
      pkgs.btop
      pkgs.pciutils
    ]
    ++ (
      if !isDarwin then
        [
          pkgs.usbutils
          pkgs.iputils
        ]
      else
        [ ]
    ) # monitoring tools
    ++ [
      pkgs.bat
      pkgs.tree
      pkgs.ranger
      pkgs.eza
    ] # file tools
    ++ [
      pkgs.wget
      pkgs.curl
      pkgs.rsync
    ]
    ++ [
      pkgs.fzf
      pkgs.ripgrep
      pkgs.autojump
      pkgs.silver-searcher
    ] # search tools
    ++ [
      pkgs.tmux
      pkgs.screen
    ]
    ++ [
      pkgs.neovim
    ]
    ++ [
      pkgs.claude-code
      pkgs.codex
    ];
  };
}
