{ lib, ... }:
let
  inherit (lib) makeExtensible;
  utils = makeExtensible (self: with self; import ./attrs.nix { inherit lib; });
in
utils.extend (
  self: super: {
    host = import ./host.nix { inherit lib; };
    module = import ./modules.nix { inherit lib; };
  }
)
