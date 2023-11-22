{ 
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}: {
  imports = [ "${modulesPath}/installer/scan/not-detected.nix" ];

  # boot parameters
  boot = {
    initrd.availableKernelModules = [ "xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" ];
    initrd.kernelModules = [];
    kernelModules = [ "kvm-intel" ];
    extraModulePackages = [];

    # load iwlwifi driver

  };

  # refuse icmp recho requests
  boot.kernel.sysctl."net.ipv4.icmp_echo_ignore_broadcasts" = 1;

  # networking
  networking.hostName = "geralt"; # Define your hostname.
  networking.networkmanager.enable = true;  # Enables wireless support via nm

# The global useDHCP flag is deprecated, therefore explicitly set to false here.
# Per-interface useDHCP will be mandatory in the future, so this generated config
# replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.wlp4s0.useDHCP = lib.mkDefault true;
  networking.interfaces.enp0s31f6.useDHCP = lib.mkDefault true;

  # disks
  fileSystems = {
    "/" = {
      device = "/dev/disk/by-label/nixos";
      # device = "/dev/disk/by-uuid/37f6ee3d-a198-4ecb-9658-3109e437e893";
      fsType = "ext4";
    };

    "/boot" = {
      device = "/dev/disk/by-label/BOOT";
      # device = "/dev/disk/by-uuid/BBF5-6E0F";
      fsType = "vfat";
    };

    "/home" = {
      device = "/dev/disk/by-label/home";
      # device = "/dev/disk/by-uuid/52753fd7-b332-47e9-a311-56952e10b150";
      fsType = "ext4";
    };
    "/media/storage" = {
      device = "/dev/disk/by-label/storage";
      fsType = "ntfs";
      options = [ "auto" "rw" "nosuid" "nofail" "user" "uid=1000" "gid=100" "exec" "umask=022"];
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

# Timezone settings
  time.timeZone = "America/New_York";
  time.hardwareClockInLocalTime = true;
  services.localtimed.enable = true;

# Some programs need SUID wrappers, can be configured further or are
# started in user sessions.
# programs.mtr.enable = true;
# programs.gnupg.agent = { enable = true; enableSSHSupport = true; };

# List services that you want to enable:

# SSHD
# Add /etc/nixos/ssh.nix to imports
# Note that ssh works without services.openssh.enable

# Firewall.
networking.firewall.enable = true;
networking.firewall.allowPing = false;
# networking.firewall.allowedTCPPorts = [ ... ];
# networking.firewall.allowedUDPPorts = [ ... ];

# Xrandr settings
services.xserver.xrandrHeads = [ 
  {
    output = "DP-4";
    primary = true;
  }
  {
    output = "HDMI-0";
  }
];

# power actions
services.logind = {
  killUserProcesses = false;
  extraConfig = "IdleAction=suspend\nIdleActionSec=300\n";
};

security.sudo.enable = true;

# Define a user account. Don't forget to set a password with ‘passwd’.
# User account info is in ./modules/users.nix

# This value determines the NixOS release with which your system is to be
# compatible, in order to avoid breaking some software such as database
# servers. You should change this only after NixOS release notes say you
# should.
system.stateVersion = "23.05"; # Did you read the comment?
}
