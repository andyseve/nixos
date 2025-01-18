# Host information file for geralt
{ ... }:
rec {
  system = "x86_64-linux";
  wsl = true;
  nixos = true;
  hardware = {
    nvidia.enable = true;
    nvidia.type = "stable";
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
  env = {
    xdg = true;
    zsh = true;
  };
  users = [ "stranger" ];

  nixosConfig =
    { ... }:
    {
      # Basic hardware configuration like disks, timezones, networking etc.
      # Only used when natively running on nixos
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

  # list of user modules to load along with appropriate config files.
  # userConfigs = mkUser users;
  # unfree = getUnfree users;

  unfree = hardware.nvidia.enable or hardware.logitech.enable;
}
