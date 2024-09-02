# Host information file
# 1. Modules - using settings from default modules
# 2. Host - function which is used in makehost to determine system settings.
# 3. Config - other customization options which are not covered my modules.
# Host config and custom settings for geralt.

{
  config,
  lib,
  pkgs,
  ...
}:
{
  # Boot settings
  boot.initrd.availableKernelModules = [
    "xhci_pci"
    "ahci"
    "nvme"
    "sd_mod"
  ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];
  hardware.enableAllFirmware = true;

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

  swapDevices = [ { device = "/dev/disk/by-label/swap"; } ];

  # Mounting Storage
  fileSystems."/media/storage" = {
    device = "/dev/disk/by-label/storage";
    fsType = "ntfs";
    options = [
      "auto"
      "rw"
      "nosuid"
      "nofail"
      "user"
      "uid=1000"
      "gid=100"
      "exec"
      "umask=022"
    ];
  };

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  nix.settings.max-jobs = lib.mkDefault 8;
  powerManagement.cpuFreqGovernor = lib.mkDefault "ondemand";

  # networking
  networking.hostName = "ziraeal";
  networking.interfaces.wlan0.useDHCP = lib.mkDefault true;

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
    networking = {
      wifi.enable = true;
    };
    services = {
      ssh.enable = true;
    };
    shell = {
      direnv.enable = true;
      utils.enable = true;
      code.cpp.enable = true;
      code.python.enable = true;
      code.haskell.enable = false;
      latex.enable = true;
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
