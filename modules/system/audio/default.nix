{
  lib,
  util,
  ...
}:
{
  provider ? "pipewire",
}:
let
  provider' = util.assertMsg (builtins.elem provider [
    "pipewire"
  ]) provider "invalid audio provider";
in
lib.mkMerge [
  (lib.mkIf (provider' == "pipewire") {
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
  })
]
