# Function definition to define hosts
# Reads settings from ../hosts/${hostname}.nix file to generate nixosSystem object
{ lib, ... }:
let
	inherit (import ./user.nix { inherit lib; }) mkUser;
	wslDefault = { config, ... }: {
		wsl.enable = true;
		wsl.nativeSystemd = true;
	};
	homeDefault = { config, ... }: {
		home-manager = {
			useGlobalPkgs = true;
			useUserPackages = true;
			backupFileExtension = "bak";
			extraSpecialArgs = {};
		};
	};
in
{
  # mkHost reads from hosts/${hostname}.nix file and creates a nixos config
	# input variables define the compilation environment, the files are loaded accordingly.
  mkHost = hostname : let
    hostConfig = if lib.hasSuffix ".nix" hostname then (import hostname { inherit lib; })
			else (import ../hosts/${hostname}.nix { inherit lib; });
		wslConfig = inputs : inputs.nixpkgs.lib.nixosSystem {
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
			};
			modules = [
				inputs.nixos-wsl.nixosModules.default
				wslDefault
				inputs.home-manager.nixosModules.home-manager
				# homeDefault
				hostConfig.wslConfig
			# ];
			] ++ (lib.flatten (builtins.map (mkUser hostConfig) hostConfig.users));
		};
		darwinConfig = inputs : inputs.darwin.lib.darwinSystem {
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
			};
			modules = [
				inputs.home-manager.darwinModules.home-manager
				# homeDefault
				hostConfig.darwinConfig
			] ++ lib.flatten (builtins.map (mkUser hostConfig) hostConfig.users);
		};
		nixosConfig = inputs : inputs.nixpkgs.lib.nixosSystem {
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
			};
			modules = [
				# homeDefault
				hostConfig.nixosConfig
			] ++ lib.flatten (builtins.map (mkUser hostConfig) hostConfig.users);
		};
  in
		{ } 
		// (if hostConfig?wsl && hostConfig.wsl then { wslConfig = wslConfig;} else {})
		// (if hostConfig?darwin && hostConfig.darwin then { darwinConfig = darwinConfig; } else {})
		// (if hostConfig?nixos  && hostConfig.nixos then { nixosConfig = nixosConfig; } else {});

	mkHostNixos = inputs: acc: hostname: configs: acc
	// (if configs?wslConfig then { "${hostname}-wsl" = (configs.wslConfig inputs); } else {})
	// (if configs?nixosConfig then { ${hostname} = (configs.nixosConfig inputs); } else {});

	mkHostDarwin = inputs: acc: hostname: configs: acc 
	// (if configs?darwinConfig then { ${hostname} = (configs.darwinConfig inputs); } else {});
}
