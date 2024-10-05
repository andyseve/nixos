{
  config,
  hostConfig,
  lib,
  options,
  pkgs,
  upkgs,
  ...
}:
let
  inherit (lib) mkIf mkMerge;
  cfg = hostConfig.shell;
in
{
  config = mkMerge [
    (mkIf cfg.utils.enable {
      environment.systemPackages =
        with pkgs;
        [ git ]
        ++ [
          zip
          unzip
        ]
        ++ [
          btop
          pciutils
          usbutils
          iputils
        ]
        ++ [
          bat
          tree
          ranger
          python3Packages.argcomplete
        ]
        ++ [
          wget
          curl
          rsync
        ]
        ++ [
          fzf
          ripgrep
          autojump
          silver-searcher
        ]
        ++ [
          tmux
          screen
        ]
        ++ [ neovim ];

    })

    (mkIf cfg.code.cpp.enable {
      environment.systemPackages = with pkgs; [
        gnumake
        gcc
        llvm
        clang
      ];
    })

    (mkIf cfg.code.python.enable {
      environment.systemPackages = with pkgs; [
        python3
        python3Packages.numpy
        python3Packages.matplotlib
      ];
    })

    (mkIf cfg.code.haskell.enable {
      environment.systemPackages = with pkgs; [
        haskellPackages.ghc
        haskellPackages.hoogle
      ];
    })

    (mkIf cfg.latex.enable {
      environment.systemPackages = with pkgs; [
        texliveFull
        texlivePackages.biber
        texlivePackages.git-latexdiff
        texlivePackages.latexdiff
      ];
    })

  ];
}
