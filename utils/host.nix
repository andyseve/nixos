# Function definition to define hosts
# Reads settings from ../hosts/${hostname}.nix file to generate nixosSystem object
{ lib, ... }:
rec {
  # mkHost reads from hosts/${hostname}.nix file and creates a nixos config
  # input variables define the compilation environment, the files are loaded accordingly.
  mkHost =
    hostname:
    let
      inherit (import ./user.nix { inherit lib; }) mkUser;
      inherit (import ./modules.nix { inherit lib; }) listModules';
      hostConfig =
        if lib.hasSuffix ".nix" hostname then
          (import hostname { inherit lib; })
        else
          (import ../hosts/${hostname}.nix { inherit lib; });
      wslDefault =
        { ... }:
        {
          wsl.enable = true;
          wsl.nativeSystemd = true;
        };
      homeDefault =
        { ... }:
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            backupFileExtension = "bak";
            extraSpecialArgs = {
              inherit hostConfig;
            };
          };
        };
      darwinDefault =
        { lib, ... }:
        {
          imports = [
            ./darwin/activation_scripts.nix
            ./darwin/launchd.nix
          ];
          # https://github.com/DeterminateSystems/determinate/blob/main/flake.nix
          # Settings specified in Determinate Systems flake.
          # Have to copy paste because no flakehub.
          # This is the important bit - force services.nix-daemon.enable = false;
          services.nix-daemon.enable = lib.mkForce false;

          # nix settings
          nix = {
            useDaemon = lib.mkForce true;
            settings = {
              netrc-file = lib.mkForce "/nix/var/determinate/netrc";
              # Post build hook is included in the default nix.conf created by determinate.
              # Effects of post-build-hook are unclear.	
              # post-build-hook = lib.mkForce "/nix/var/determinate/post-build-hook.sh";
              # upgrade-nix-store-path-url = lib.mkForce "https://install.determinate.systems/nix-upgrade/stable/universal";
            };
          };
        };

      wslConfig =
        inputs:
        inputs.nixpkgs.lib.nixosSystem {
          system = hostConfig.system;
          pkgs = import inputs.nixpkgs {
            system = hostConfig.system;
            config.allowUnfree = hostConfig.unfree;
          };
          specialArgs = {
            inherit hostConfig;
            upkgs = import inputs.unstable {
              system = hostConfig.system;
              config.allowUnfree = hostConfig.unfree;
            };
            home-manager = inputs.home-manager;
            nixos-wsl = inputs.nixos-wsl;
            isWSL = true;
            isDarwin = false;
            isNixos = false;
          };
          modules =
            [
              inputs.nixos-wsl.nixosModules.default
              wslDefault
              inputs.home-manager.nixosModules.home-manager
              homeDefault
              hostConfig.wslConfig
            ]
            ++ (lib.flatten (builtins.map (mkUser hostConfig) hostConfig.users))
            ++ (listModules' (toString ../modules));
        };

      darwinConfig =
        inputs:
        inputs.darwin.lib.darwinSystem {
          system = hostConfig.system;
          pkgs = import inputs.nixpkgs {
            system = hostConfig.system;
            config.allowUnfree = hostConfig.unfree;
          };
          specialArgs = {
            inherit hostConfig;
            upkgs = import inputs.unstable {
              system = hostConfig.system;
              config.allowUnfree = hostConfig.unfree;
            };
            home-manager = inputs.home-manager;
            darwin = inputs.darwin;
            determinate = inputs."determinate-nixd-${hostConfig.system}";
            nix-homebrew = inputs.nix-homebrew;
            isWSL = false;
            isDarwin = true;
            isNixos = false;
          };
          modules =
            [
              inputs.nix-homebrew.darwinModules.nix-homebrew
              darwinDefault
              inputs.home-manager.darwinModules.home-manager
              homeDefault
              hostConfig.darwinConfig
            ]
            ++ (lib.flatten (builtins.map (mkUser hostConfig) hostConfig.users))
            ++ (listModules' (toString ../modules));
        };

      nixosConfig =
        inputs:
        inputs.nixpkgs.lib.nixosSystem {
          system = hostConfig.system;
          pkgs = import inputs.nixpkgs {
            system = hostConfig.system;
            config.allowUnfree = hostConfig.unfree;
          };
          specialArgs = {
            inherit hostConfig;
            upkgs = import inputs.unstable {
              system = hostConfig.system;
              config.allowUnfree = hostConfig.unfree;
            };
            home-manager = inputs.home-manager;
            hyprland = inputs.hyprland;
            isWSL = false;
            isDarwin = false;
            isNixos = true;
          };
          modules =
            [
              inputs.home-manager.nixosModules.home-manager
              homeDefault
              hostConfig.nixosConfig
            ]
            ++ (lib.flatten (builtins.map (mkUser hostConfig) hostConfig.users))
            ++ (listModules' (toString ../modules));
        };
    in
    { }
    // (if hostConfig ? wsl && hostConfig.wsl then { wslConfig = wslConfig; } else { })
    // (if hostConfig ? darwin && hostConfig.darwin then { darwinConfig = darwinConfig; } else { })
    // (if hostConfig ? nixos && hostConfig.nixos then { nixosConfig = nixosConfig; } else { });

  mkHostNixos =
    inputs: acc: hostname: configs:
    acc
    // (if configs ? wslConfig then { "${hostname}-wsl" = (configs.wslConfig inputs); } else { })
    // (if configs ? nixosConfig then { "${hostname}" = (configs.nixosConfig inputs); } else { });

  mkHostDarwin =
    inputs: acc: hostname: configs:
    acc // (if configs ? darwinConfig then { "${hostname}" = (configs.darwinConfig inputs); } else { });
}
