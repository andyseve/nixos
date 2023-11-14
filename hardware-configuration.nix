{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [ "${modulesPath}/installer/scan/not-detected.nix" ];

  # boot parameters
  boot = {
    initrd.availableKernelModules = [ "xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" ];
    initrd.kernelModules = [];
    kernelModules = [ "kvm-intel" ];
    extraModulePackages = [];

    # refuse icmp recho requests
    kernel.sysctl."net.ipv4.icmp_echo_ignore_broadcasts" = 1;
  };

  # networking
  networking.interfaces.wlp4s0.useDHCP = lib.mkDefault true;
  networking.interfaces.enp0s31f6.useDHCP = lib.mkDefault true;

  # disks
  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/37f6ee3d-a198-4ecb-9658-3109e437e893";
      fsType = "ext4";
    };

    "/boot" = {
      device = "/dev/disk/by-uuid/BBF5-6E0F";
      fsType = "vfat";
    };

    "/home" = {
      device = "/dev/disk/by-uuid/52753fd7-b332-47e9-a311-56952e10b150";
      fsType = "ext4";
    };
  };

  # swap
  swapDevices = [
    { device = "/dev/disk/by-uuid/2763214b-574d-4fa0-97ff-637f7722e526"; }
  ];

  # CPU
  nix.settings.max-jobs = lib.mkDefault 4;
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  powerManagement.cpuFreqGovernor = lib.mkDefault "performance";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
