{ config, lib, option, ... }:
let
	inherit (lib) mkDefault mkIf mkMerge mkOption;
{
	options = mkMerge [
		(mkIf isDarwin {
			environment.sessionVariables = mkOption {
				type = lib.type.str;
				description = "filler option to stop errors";
			};
		})
	];
}
