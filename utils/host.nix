# Function definition to define hosts
# Reads settings from ../hosts/${hostname}.nix file to generate nixosSystem object
{ lib, ... }:
let
	mkUser = import ./user.nix { inherit lib; };
	mkHome = username : modules : 
	wslDefault = { config, ... }: {
		wsl.enable = true;
	};
	homeDefault = { config, ... }: {
		home-manager = {
			useGlobalPkgs = true;
			useUserPkgs = true;
			backupFileExtension = "bak";
			extraSpecialArgs = {}
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
			};
			modules = [
				inputs.nixos-wsl.nixosModules.default
				inputs.home-manager.nixosModules.home-manager
				wslDefault
				hostConfig.wslConfig
			] ++ (builtins.map (mkUser hostConfig) hostConfig.users);
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
				hostConfig.darwinConfig
			] ++ (builtins.map (mkUser hostConfig) hostConfig.users);
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
				hostConfig.hardwareConfig
			] ++ (builtins.map (mkUser hostConfig) hostConfig.users);
		};
  in
		{
			wslConfig = wslConfig;
			darwinConfig = darwinConfig;
			nixosConfig = nixosConfig;
		};
}
