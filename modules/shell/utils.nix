{
  config,
  hostConfig,
  isDarwin,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf mkMerge;
  cfg = hostConfig.shell or { };
in
{
  config = mkMerge [
    (mkIf (cfg.utils.enable or false) {
      environment.systemPackages =
        [ pkgs.git ] # Version Control
        ++ [
          pkgs.zip
          pkgs.unzip
        ] # archieves
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
        ++ [ pkgs.neovim ];

    })

    (mkIf (cfg.code.cpp.enable or false) {
      environment.systemPackages = [
        pkgs.gnumake
        pkgs.gcc
        pkgs.llvm
      ];
    })

    (mkIf (cfg.code.python.enable or false) {
      environment.systemPackages = [
        pkgs.python3
        pkgs.python3Packages.numpy
        pkgs.python3Packages.scipy
        pkgs.python3Packages.torch
        pkgs.python3Packages.matplotlib
      ];
    })

    (mkIf (cfg.code.haskell.enable or false) {
      environment.systemPackages = [
        pkgs.haskellPackages.ghc
        pkgs.haskellPackages.hoogle
      ];
    })

    (mkIf (cfg.latex.enable or false) {
      environment.systemPackages = [
        pkgs.texliveFull
        pkgs.texlivePackages.biber
        pkgs.texlivePackages.git-latexdiff
        pkgs.texlivePackages.latexdiff
      ];
    })

  ];
}
