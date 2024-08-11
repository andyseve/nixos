
{
  config,
  options,
  lib,
  pkgs,
  ...
}:

with lib;
let
  modules = config.modules;
in {
  options.modules.system = mkOption {
    description = "host system";
    type = types.str;
    default = "x86_64-linux";
    example = "x86_64-linux";
  };

  config.system = lib.mkDefault options.modules.system;
}
