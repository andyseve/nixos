# setting up xdg environment variables
{
  config,
  options,
  lib,
  ...
}:

with lib;
let
  cfg = config.modules.xdg;
in {
  options.modules.env = {
    xdg = mkOption {
      description = "set up default xdg locations";
      type = types.bool;
      default = true;
      example = false;
    };
    zsh = mkOption {
      description = "set up zdotdir inside XDG_CONFIG_HOME";
      type = types.bool;
      default = false;
      example = true;
    };
  };

  config = mkMerge [

    ( mkIf cfg.enable {
      environment.sessionVariables = {
        # xdg default settings
        XDG_CACHE_HOME  = "$HOME/.cache";
        XDG_CONFIG_HOME = "$HOME/.config";
        XDG_DATA_HOME   = "$HOME/.local/share";
        XDG_STATE_HOME  = "$HOME/.local/state";

        # XDG_BIN_HOME is not included in official specifications
        XDG_BIN_HOME    = "$HOME/.local/bin";
      };
      environment.variables = {
        LESSHISTFILE = "$XDG_CACHE_HOME/lesshst";
        WGETRC = "$XDG_CONFIG_HOME/wgetrc";
      };
    })

    ( mkIf cfg.zsh {
      programs.zsh = {
        enable = true;
        enableCompletion = true;
      };
      environment.variables = {
        ZDOTDIR = "$XDG_CONFIG_HOME/zsh";
        HISTFILE = "$ZDOTDIR/zsh_history";
      };
    })

  ];
}
