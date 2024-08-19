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
  cfg = config.anish-sevekari-modules.shell.utils;
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
        types = types.bool;
        default = false;
      };
      python.enable = mkOption {
        description = "enable python";
        types = types.bool;
        default = false;
      };
      haskell.enable = mkOption {
        description = "enable cpp";
        types = types.bool;
        default = false;
      };
    };
    latex.enable = mkOption {
      description = "enable latex";
      types = types.bool;
      default = false;
    };
  };

  config = mkMerge [

    (mkIf cfg.enable {
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
        ]
        ++ [
          tree
          ranger
          upkgs.python3Packages.argcomplete
        ]
        ++ [
          wget
          curl
          rsync
        ]
        ++ [
          ripgrep
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
