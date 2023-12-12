{
  config,
  options,
  lib,
  ...
}:

with lib;
let 
  cfg = config.modules.services.ssh;
in {
  options.modules.services.ssh = {
    enable = mkOption {
      description = "enable ssh server";
      type = types.bool;
      default = false;
      example = true;
    };

    # turn on ssh agent
    agent = mkOption {
      description = "enable ssh agent";
      type = types.bool;
      default = false;
      example = true;
    };
  };

  config = mkIf cfg.enable (mkMerge [
    {
      services.openssh = {
        enable = true;
        allowSFTP = true;
        settings.X11Forwarding = false;
        settings.logLevel = "VERBOSE";
        ports = [ 22 ];
        settings.PermitRootLogin = "no";
        settings.PasswordAuthentication = false;

        extraConfig = ''
          # Authentication
          LoginGraceTime 2m
          StrictModes yes
          MaxAuthTries 3
          MaxSessions 5

          PubkeyAuthentication yes
          PermitEmptyPasswords no

          # Config
          PrintLastLog yes
          TCPKeepAlive yes
          '';
      };
    }

    (mkIf cfg.agent {
      programs.ssh = {
        startAgent = true;
        agentTimeout = "30m";
      };
    })
  ]);
}
