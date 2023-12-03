{
  lib,
  ...
}:
let
  inherit (lib) makeExtensible;
  attrs = import ./attrs.nix { inherit lib; };
  myutils = makeExtensible (self: attrs);
in
  myutils.extend (self: super: {
    host = import ./host.nix { inherit lib; };
    module = import ./modules.nix { inherit lib; };
  })
