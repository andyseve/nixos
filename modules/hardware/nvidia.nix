{ lib, pkgs, hostConfig, isWSL, ... }:
let
  nvidiaEnabled =
    hostConfig ? hardware
    && hostConfig.hardware ? nvidia
    && (hostConfig.hardware.nvidia.enable or false);
in
{
  config = lib.mkIf (isWSL && nvidiaEnabled) {
    # Expose GL stack and GPU tools inside WSL for NVIDIA passthrough.
    hardware.graphics = {
      enable = true;
      enable32Bit = false;
      extraPackages = with pkgs; [ mesa.drivers ];
    };

    environment.systemPackages = with pkgs; [
      mesa-utils
      cudaPackages.nvidia-smi
    ];
  };
}
