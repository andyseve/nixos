{
  lib,
  ...
}:

with builtins;
with lib;
{
  countAttrs = pred: attrs: (
    count
    (attr: pred attr.name attr.value)
    (mapAttrsToList (name: value: { inherit name value; }) attrs)
  );
}
