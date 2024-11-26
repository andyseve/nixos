{
  isDarwin,
  options,
  pkgs,
  ...
}:
{
  # Basic Nix configuration
  nix = {
    # flakes
    package = pkgs.nix;

    # build related settings
    settings = {
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

    optimise.automatic = true; # auto-optimize the store

    # Garbage Collector
    gc =
      {
        automatic = true;
        options = "--delete-older-than 30d";
      }
      // (
        if isDarwin then
          {
            interval = {
              Weekday = 0;
              Hour = 2;
              Minute = 0;
            };
          }
        else
          { dates = "weekly"; }
      );
  };

  environment.systemPackages = [
    pkgs.coreutils
    pkgs.curl
    pkgs.git
    pkgs.ripgrep
    pkgs.wget
    pkgs.neovim
  ];

  # enable zsh
  programs.zsh.enable = true;

  # enable nix daemon on apple
  # system settings
  system.stateVersion = (if isDarwin then 5 else "24.05");
}
