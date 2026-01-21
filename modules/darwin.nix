{
  lib,
  isDarwin,
  ...
}:
let
  # MAS installs can hang without an App Store session; gate with env.
  manageMasApps = builtins.getEnv "MANAGE_MAS_APPS" == "1";
in
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
          user = "stranger";
          caskArgs.no_quarantine = true;
          onActivation = {
            autoUpdate = false;
            upgrade = true;
            cleanup = "uninstall"; # should maybe be "zap" - remove anything not listed here
          };
          global = {
            brewfile = false;
            autoUpdate = false;
          };
          masApps = lib.mkIf manageMasApps {
            "Keynote" = 409183694;
            "Microsoft Excel" = 462058435;
            "Microsoft Word" = 462054704;
            "Microsoft PowerPoint" = 462062816;
            "Microsoft OneNote" = 784801555;
            "Xcode" = 497799835;
            # "GlobalProtect" = 1400555706;
          };
        };
      }
    else
      { };
}
