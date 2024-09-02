{
  config,
  options,
  lib,
  pkgs,
  upkgs,
  ...
}:

with lib;
let
  cfg = config.anish-sevekari-modules.shell;
in
{
  options.anish-sevekari-modules.shell = {
    utils.enable = mkOption {
      description = "enable utils";
      type = types.bool;
      default = true;
    };

    code = {
      cpp.enable = mkOption {
        description = "enable cpp";
        type = types.bool;
        default = false;
      };
      python.enable = mkOption {
        description = "enable python";
        type = types.bool;
        default = false;
      };
      haskell.enable = mkOption {
        description = "enable cpp";
        type = types.bool;
        default = false;
      };
    };

    latex.enable = mkOption {
      description = "enable latex";
      type = types.bool;
      default = false;
    };
  };

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
