{
  nixpkgs,
  unstable,
  lib,
  ...
}: rec {
  host = import ./host.nix { inherit nixpkgs unstable lib; };
}
