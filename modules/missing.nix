{ isDarwin, lib, ... }:
let
  inherit (lib) mkOption;
in
{
  options =
    if isDarwin then
      {
        environment.sessionVariables = mkOption {
          type = lib.type.str;
          description = "filler option to stop errors";
        };
      }
    else
      { };
}
