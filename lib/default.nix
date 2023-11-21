{
  lib,
  ...
}:
let
  inherit (lib) makeExtensible;
  myutils = makeExtensible (self: { });
in
  myutils.extend (self: super: {
    host = import ./host.nix { inherit lib; };
    module = import ./modules.nix { inherit lib; };
  })
