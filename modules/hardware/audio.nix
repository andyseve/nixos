{
  config,
  options,
  lib,
  ...
}:

with lib;
let
  cfg = config.modules.hardware.audio;
in {
  options.modules.hardware.audio = {
    enable = mkOption {
      description = "enable audio capabilities";
      type = types.bool;
      default = false;
      example = true;
    };
  };

  config = mkIf cfg.enable {
    # disable pulseaudio by default
    hardware.pulseaudio.enable = mkDefault false;

    # use pipewire
    services.pipewire = mkDefault {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };

    # enable rtkit
    # rtkit manages priorities of realtime services
    security.rtkit.enable = mkDefault true;
  };
}
