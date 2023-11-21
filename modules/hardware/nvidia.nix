{ options, config, lib, pkgs, ... }:

with lib;
let
  cfg = config.modules.hardware.nvidia;
in {
  options.modules.hardware.nvidia = {
    enable = mkOption {
      description = "enable nvidia gpu drivers";
      type = types.bool;
      default = false;
      example = true;
    };

    type = mkOption {
      description = "type of nvidia drivers, points to nvidia package";
      type = types.string;
      default = "stable";
      example = "legacy_390";
    };
  };

  config = mkIf cfg.enable (mkMerge [
    {
      services.xserver.videoDrivers = [ "nvidia" ];

      hardware.nvidia = {
        package = config.boot.kernelPackages.nvidiaPackages.${cfg.type};
        nvidiaSettings = true;
      };

      hardware.opengl = {
        enable = true;
        driSupport = true;
        driSupport32Bit = true;
      };

      environment.systemPackages = with pkgs; [
        # Respecting XDG conventions
        (writeScriptBin "nvidia-settings" ''
          #!${stdenv.shell}
          mkdir -p "$XDG_CONFIG_HOME/nvidia"
          exec ${config.boot.kernelPackages.nvidia_x11.settings}/bin/nvidia-settings --config="$XDG_CONFIG_HOME/nvidia/settings"
        '')
      ];
    }
    
    (mkIf (hasPrefix "legacy" cfg.type) {
      hardware.nvidia = {
        powerManagement.enable = false;
        powerManagement.finegrained = false;
        open = false;
        prime = {
          sync.enable = lib.mkDefault true;
          offload.enable = lib.mkDefault false;
        };
      };
    })
  ]);
}
