{
	config,
	isDarwin,
	lib,
	nix-homebrew,
	options,
	pkgs,
	...
}: let
	inherit (lib) hasPrefix;
in {
	config = if isDarwin then {
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
				# "iMovie" = 408981434;
				# "Keynote" = 409183694;
				# "Microsoft Excel" = 462058435;
				# "Microsoft Word" = 462054704;
				# "Microsoft PowerPoint" = 462062816;
				"Slack" = 803453959;
				"Xcode" = 497799835;
			};
		};
	} else {};
}
