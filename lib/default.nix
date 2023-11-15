{
  lib,
  ...
}:

{
  host = import ./host.nix { inherit lib; };
  modules = import ./modules.nix { inherit lib; };
}
