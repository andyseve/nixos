# Function definition to define hosts
# Reads settings from ../hosts/${hostname}.nix file to generate nixosSystem object
{ lib, ... }:
let
  mkUser = import ./user.nix { inherit lib; };
in
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
        { config, ... }:
        {
          wsl.enable = true;
          wsl.nativeSystemd = true;
        };
      homeDefault =
        inputs:
        { config, ... }:
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
            darwin = inputs.darwin;
            isWSL = true;
            isDarwin = false;
            isNixos = false;
          };
          modules =
            [
              inputs.nixos-wsl.nixosModules.default
              wslDefault
              inputs.home-manager.nixosModules.home-manager
              (homeDefault inputs)
              hostConfig.wslConfig
            ]
            ++ (lib.flatten (builtins.map (mkUser hostConfig) hostConfig.users))
            ++ (listModules' (toString ../base));
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
            nixos-wsl = inputs.nixos-wsl;
            darwin = inputs.darwin;
            isWSL = false;
            isDarwin = true;
            isNixos = false;
          };
          modules =
            [
              inputs.home-manager.darwinModules.home-manager
              (homeDefault inputs)
              hostConfig.darwinConfig
            ]
            ++ (lib.flatten (builtins.map (mkUser hostConfig) hostConfig.users))
            ++ (listModules' (toString ../base));
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
            nixos-wsl = inputs.nixos-wsl;
            darwin = inputs.darwin;
            isWSL = false;
            isDarwin = false;
            isNixos = true;
          };
          modules =
            [
              inputs.home-manager.nixosModules.home-manager
              (homeDefault inputs)
              hostConfig.nixosConfig
            ]
            ++ (lib.flatten (builtins.map (mkUser hostConfig) hostConfig.users))
            ++ (listModules' (toString ../base));
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
