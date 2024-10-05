{ lib, ... }:

let
  inherit (builtins) count pathExists readDir;
  inherit (lib)
    filterAttrs
    hasSuffix
    mapAttrs
    mapAttrs'
    mapAttrsToList
    nameValuePair
    removeSuffix
    ;
in
{
  # extract file names from a directory
  # filters to keep only the files with .nix extension
  fileNames =
    dir:
    let
      files = filterAttrs (name: value: value == "regular" && hasSuffix ".nix" name) (readDir dir);
      getNames = name: value: nameValuePair (removeSuffix ".nix" name) value;
    in
    mapAttrs' getNames files;

  countAttrs =
    pred: attrs:
    (count (attr: pred attr.name attr.value) (
      mapAttrsToList (name: value: { inherit name value; }) attrs
    ));

  extractAttrs = name: attrs: mapAttrs (n: v: v.${name}) attrs;

  applyAttrsOnArgs = args: attrs: mapAttrs (n: v: v args) attrs;

  isWSL = pathExists "/proc/sys/fs/binfmt_misc/WSLInterop";
}
// import ./modules.nix { inherit lib; }
// import ./host.nix { inherit lib; }
// import ./user.nix { inherit lib; }
