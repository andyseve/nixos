{
  config,
  options,
  lib,
  pkgs,
  ...
}:

let
  lib.utils = import ./lib { lib = lib.debug.traceSeq lib; };
in {
  imports = (lib.utils.modules.listModules (toString ./modules));
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
      ];
      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
    };

    # Garbage Collector
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };
  
  # system settings
  system.stateVersion = lib.mkDefault "23.05";

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
