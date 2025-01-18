{
  config,
  isDarwin,
  nix-homebrew,
  ...
}:
{
  config =
    if isDarwin then
      {
        nix-homebrew = {
          enable = true;
          # enableRosetta = (hasPrefix "aarch64" pkgs.stdenv.system);
          user = "stranger";
          # mutableTaps = false;
          # autoMigrate = false;
        };
        homebrew = {
          enable = true;
          caskArgs.no_quarantine = true;
          onActivation = {
            autoUpdate = false;
            upgrade = true;
            cleanup = "uninstall"; # should maybe be "zap" - remove anything not listed here
          };
          global = {
            brewfile = true;
            autoUpdate = false;
          };
          masApps = {
            "Keynote" = 409183694;
            "Microsoft Excel" = 462058435;
            "Microsoft Word" = 462054704;
            "Microsoft PowerPoint" = 462062816;
            "Microsoft OneNote" = 784801555;
            "Slack" = 803453959;
            "Xcode" = 497799835;
            # "GlobalProtect" = 1400555706;
          };
        };
      }
    else
      { };
}
