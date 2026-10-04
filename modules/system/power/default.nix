{
  lib,
  util,
  ...
}:
{
  profile,
}:
let
  profile = util.assertMsg (builtins.elem profile [ "laptop" ]) profile "invalid power profile";
in
lib.mkMerge [
  (lib.mkIf (profile == "laptop") {
    services.thermald.enable = true;
    services.tlp.enable = true;
  })
]
