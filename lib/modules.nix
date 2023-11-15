{ lib, ...} :

let
  inherit (builtins) readDir pathExists concatLists;
  inherit (lib) hasSuffix mapAttrsToList filterAttrs;
  # mapFilterAttrs = pred: f: attrs: filterAttrs pred (mapAttrs' f attrs);
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

  # maps a function fn on all files and directories in dir
  # example = mapModules (toString ../modules) import
  # mapModules = dir: fn:
  # mapFilterAttrs
  # (n: v: v != null && !(hasPrefix "_" n))
  # (n :v: 
  # let path = "${toString dir}/${n}"; in
  #   if v == "directory"
  #   then nameValuePair n (mapModules path fn)
  #   else if v == "regular" && n != "default.nix" && hasSuffix ".nix" n
  #   then nameValuePair (removeSuffix ".nix" n) (fn path)
  #   else nameValuePair "" null)
  #   (readDir dir);
}
