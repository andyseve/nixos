{
  config,
  hostConfig,
  isDarwin,
  lib,
  options,
  pkgs,
  upkgs,
  ...
}:
let
  inherit (lib) mkIf mkMerge;
  cfg = hostConfig.shell or {};
in
{
  config = mkMerge [
    (mkIf (cfg.utils.enable or false) {
      environment.systemPackages =
        with pkgs;
        [ git ] # Version Control
        ++ [
          zip
          unzip
        ] # archieves
        ++ [
          btop
          pciutils
        ] 
	++ (if !isDarwin then [
		usbutils
          	iputils
	] else []) # monitoring tools
        ++ [
          bat
          tree
          ranger
        ] # file tools
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
        ] # search tools
        ++ [
		python3Packages.argcomplete
	] # completion
        ++ [
          tmux
          screen
        ]
        ++ [ neovim ];

    })

    (mkIf (cfg.code.cpp.enable or false) {
      environment.systemPackages = with pkgs; [
        gnumake
        gcc
        llvm
        clang
      ];
    })

    (mkIf (cfg.code.python.enable or false) {
      environment.systemPackages = with pkgs; [
        python3
        python3Packages.numpy
        python3Packages.matplotlib
      ];
    })

    (mkIf (cfg.code.haskell.enable or false) {
      environment.systemPackages = with pkgs; [
        haskellPackages.ghc
        haskellPackages.hoogle
      ];
    })

    (mkIf (cfg.latex.enable or false) {
      environment.systemPackages = with pkgs; [
        texliveFull
        texlivePackages.biber
        texlivePackages.git-latexdiff
        texlivePackages.latexdiff
      ];
    })

  ];
}
