self: super: {
  pkgs = import nixpkgs { config.allowUnfree = true; };
  unstable = import nixpkgs-unstable { config.allowUnfree = true; };
}
