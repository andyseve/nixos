# Host information file
# 1. Modules - using settings from default modules
# 2. Host - function which is used in makehost to determine system settings.
# 3. Config - other customization options which are not covered my modules.
# Host config and custom settings for geralt.

{ 
  inputs,
  config,
  lib,
  pkgs,
  ...
}: {
  # Boot settings
  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" "sr_mod" "rtsx_pci_sdmmc" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  # Timezone settings
  time.timeZone = "America/New_York";
  time.hardwareClockInLocalTime = false;  

  # Defining mount points
  # Mounting Home
  fileSystems."/boot" = {
    device = "/dev/disk/by-label/boot";
    fsType = "vfat";
  };
  
  fileSystems."/" = {
    device = "/dev/disk/by-label/nixos";
    fsType = "ext4";
  };

  fileSystems."/home" = { 
    device = "/dev/disk/by-label/home";
    fsType = "ext4";
    options = [ "defaults" ];
  };

  swapDevices = [
    { device = "/dev/disk/by-lable/swap"; }
  ];

  # Nvidia Prime Settings
  hardware.nvidia.prime = lib.mkDefault {
      nvidiaBusId = "PCI:4:0:0";
      intelBusId  = "PCI:0:2:0";
  };

  nix.settings.max-jobs = lib.mkDefault 4;
  powerManagement.cpuFreqGovernor = lib.mkDefault "ondemand";

  # networking
  networking.hostName = "vesemir";
  networking.interfaces.enp2s0f1.useDHCP = lib.mkDefault true;
  networking.interfaces.wlp3s0f0.useDHCP = lib.mkDefault false;

  # Open ports in the firewall.
  networking.firewall.enable = true;
  networking.firewall.allowPing = false;
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];

  # Power actions
  services.logind = {
    killUserProcesses = false;
    lidSwitch = "hibernate";
    lidSwitchExternalPower = "ignore";
    lidSwitchDocked = "ignore";
  };

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "24.05"; # Did you read the comment?

  # My module settings.
  anish-sevekari-modules = {
    hardware = {
      audio.enable = true;
    };
    services = {
      ssh.enable = true;
    };
    shell = {
      direnv.enable = true;
    };
    desktop = {
      enable = true;
      wm.hyprland.enable = true;
    };
    env = {
      xdg = true;
      zsh = true;
    };
  };
}

