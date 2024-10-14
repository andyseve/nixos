{
  config,
	isDarwin,
  lib,
  options,
  pkgs,
  ...
}: let
	inherit (lib) mkDefault;
in {
  # Basic Nix configuration
  nix = {
    # flakes
    package = pkgs.nixFlakes;
    extraOptions = "experimental-features = nix-command flakes";
    # build related settings
    settings = {
      auto-optimise-store = true;
      require-sigs = true;
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      substituters = [
        "https://cache.nixos.org"
        "https://nix-community.cachix.org"
        "https://cuda-maintainers.cachix.org"
        "https://hyprland.cachix.org"
      ];
      trusted-substituters = [
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
      accept-flake-config = true;
    };

    # Garbage Collector
    gc = {
      automatic = true;
      options = "--delete-older-than 30d";
    } 
    // (if isDarwin then {
    	interval = { Weekday = 0; Hour = 2; Minute = 0; };
    } else {
    	dates = "weekly";
    });
  };


	environment.systemPackages = [
		pkgs.coreutils
		pkgs.curl
		pkgs.git
		pkgs.ripgrep
		pkgs.wget
		pkgs.neovim
	];

	# enable nix daemon on apple
  # system settings
  system.stateVersion = (if isDarwin then 5 else "24.05");
}
// (if isDarwin then {
	# darwin specific options
	services.nix-daemon.enable = true;
	} else {})
