# user settings
{lib, hostConfig, ... }:
let
	home = if hostConfig?home then hostConfig.home else "/home";
	username = "stranger";
	name = "Anish Sevekari";
	shell = "zsh";
in rec {
	userConfig = { config, lib, pkgs, ... }: {
		users.users.${username} = {
			isNormalUser = true;
			home = "${home}/${username}";
			description = name;
			createHome = true;
			shell = "${pkgs.${shell}}/bin/${shell}";
		};
	};

	homeConfig = { config, lib, pkgs, home-manager, ... }: {
		home.stateVersion = "24.05";
		home.sessionVariables = {
			PAGER = "less";
			EDITOR = "nvim";
			XDG_CACHE_HOME = "$HOME/.cache";
			XDG_CONFIG_HOME = "$HOME/.config";
			XDG_DATA_HOME = "$HOME/.local/share";
			XDG_STATE_HOME = "$HOME/.local/state";
			ZDOTDIR = "$XDG_CONFIG_HOME/zsh";
			HISTFILE = "$ZDOTDIR/zsh_history";
		};
		home-manager.users.${username}.imports = [
		];
	};
}
