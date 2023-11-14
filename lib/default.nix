{
  inputs,
  lib,
  ...
}:

{
  host = import ./host.nix { inherit inputs lib; };
}
