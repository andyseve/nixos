# Host information file for geralt
{ ... }:
rec {
  system = "x86_64-linux";
  nixos = true;
  unfree = true;
  hardware = {
    # nvidia.enable = true;
    # nvidia.type = "stable";
    audio.enable = true;
    logitech.enable = true;
  };
  networking.wifi.enable = true;
  services.ssh.enable = true;
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
  users = [ "stranger" ];

  nixosConfig =
    { options, ... }:
    {
      # Basic hardware configuration like disks, timezones, networking etc.
      # Only used when natively running on nixos
      # boot settings
      boot.loader.systemd-boot.enable = true;
      boot.loader.efi.canTouchEfiVariables = true;
      boot.initrd.availableKernelModules = [
        "xhci_pci"
        "ahci"
        "usbhid"
        "sd_mod"
      ];
      boot.initrd.kernelModules = [ ];
      boot.kernelModules = [ "kvm-intel" ];
      boot.extraModulePackages = [ ];

      #time.timeZone = "America/New_York";
      time.hardwareClockInLocalTime = true;
      services.localtimed.enable = true;

      # Defining mount points
      fileSystems."/" = {
        device = "/dev/disk/by-uuid/37f6ee3d-a198-4ecb-9658-3109e437e893";
        fsType = "ext4";
      };

      fileSystems."/home" = {
        device = "/dev/disk/by-uuid/52753fd7-b332-47e9-a311-56952e10b150";
        fsType = "ext4";
      };

      fileSystems."/boot" = {
        device = "/dev/disk/by-uuid/BBF5-6E0F";
        fsType = "vfat";
      };

      swapDevices = [
        { device = "/dev/disk/by-uuid/2763214b-574d-4fa0-97ff-637f7722e526"; }
      ];

      # Mounting Storage
      fileSystems."/media/storage" = {
        device = "/dev/disk/by-label/Storage";
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

      networking.hostName = "geralt"; # Define your hostname.
      networking.networkmanager.enable = true; # Enables wireless support via nm

      # The global useDHCP flag is deprecated, therefore explicitly set to false here.
      # Per-interface useDHCP will be mandatory in the future, so this generated config
      # replicates the default behaviour.
      networking.useDHCP = false;
      networking.interfaces.wlp4s0.useDHCP = true;

      # Network Proxy
      # networking.proxy.default = "http://user:password@proxy:port/";
      # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

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
      # system.stateVersion = "23.05"; # Did you read the comment?
      system.stateVersion = "24.11";
    };

  wslConfig =
    { lib, ... }:
    {
      # Config options for wsl
      # only imported when running in windows subsystem for linux
      networking.hostName = "geralt";
      nix.settings.max-jobs = lib.mkForce 4;
      wsl.defaultUser = "stranger";
    };

  darwinConfig =
    { ... }:
    {
      # Config options for darwin (MacOS)
      # only imported when running on MacOS using nix-darwin
    };
}
