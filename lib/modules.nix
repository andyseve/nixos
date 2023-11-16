{ lib, ...} :

let
  inherit (builtins) readDir pathExists concatLists;
  inherit (lib) hasSuffix mapAttrs mapAttrsToList concatMapAttrs filterAttrs;
in rec {
  # lists all the paths in dir
  # if a subdirectory includes "default.nix" then ignores all subdirectories and other files
  listModules = dir:
  let 
    # default is true if dir contents default.nix
    default = pathExists "${toString dir}/default.nix";
    contents = readDir dir;
    directories = filterAttrs (name: value: value == "directory") contents;
    files = filterAttrs (name: value: value == "regular" && hasSuffix ".nix" name) contents;
  in
    if default == true then [ "${toString dir}/default.nix" ]
    else mapAttrsToList (name: value: "${toString dir}/${name}") files ++ concatLists (mapAttrsToList (name: value: listModules "${toString dir}/${name}") directories);

  # same function as above, but does not treat default.nix differently
  listModules' = dir:
  let 
    # default is true if dir contents default.nix
    contents = readDir dir;
    directories = filterAttrs (name: value: value == "directory") contents;
    files = filterAttrs (name: value: value == "regular" && hasSuffix ".nix" name) contents;
  in
    mapAttrsToList (name: value: "${toString dir}/${name}") files ++ concatLists (mapAttrsToList (name: value: listModules' "${toString dir}/${name}") directories);

  # maps a function fn on all files and directories in dir and returns values as a attrset
  # if a subdirectory contains default.nix then only function is only applied to that file.
  # example = mapModules (toString ../modules) import
  mapModules = fn: dir:
  let
    # default is true if dir contents default.nix
    default = pathExists "${toString dir}/default.nix";
    contents = readDir dir;
    directories = filterAttrs (name: value: value == "directory") contents;
    files = filterAttrs (name: value: value == "regular" && hasSuffix ".nix" name) contents;
  in
  if default == true then { "${toString dir}/default.nix" = (fn "${toString dir}/default.nix"); }
  else mapAttrs (name: value: (fn "${toString dir}/${name}")) files // concatMapAttrs (name: value: mapModules fn "${toString dir}/${name}") directories;
}
