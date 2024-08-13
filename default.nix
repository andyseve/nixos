{
  config,
  options,
  lib,
  pkgs,
  ...
}: {
  # imports
  imports = (lib.myutils.module.listModules' (toString ./modules));
  # Nix configuration
  nix = {
    # flakes
    package = pkgs.nixFlakes;
    extraOptions = "experimental-features = nix-command flakes";
    # build related settings
    settings = {
      auto-optimise-store = true;
      require-sigs = true;
      experimental-features = ["nix-command" "flakes"];
      substituters = [
        "https://cache.nixos.org"
        "https://nix-community.cachix.org"
        "https://cuda-maintainers.cachix.org"
	    "https://hyprland.cachix.org"
      ];
      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "cuda-maintainers.cachix.org-1:0dq3bujKpuEPMCX6U4WylrUDZ9JyUG0VpVZa7CNfq5E="
	    "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      ];
    };

    # Garbage Collector
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };

  # Allow unfree
  nixpkgs.config.allowUnfree = true;

  # system settings
  system.stateVersion = lib.mkDefault "24.05";

  # Boot options
  boot = {
    loader = {
      efi.canTouchEfiVariables = lib.mkDefault true;
      systemd-boot.configurationLimit = lib.mkDefault 10;
      systemd-boot.enable = lib.mkDefault true;
    };
    plymouth.enable = true;
  };
}
