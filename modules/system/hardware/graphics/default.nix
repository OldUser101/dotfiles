{
  pkgs,
  lib,
  util,
  ...
}:
{
  type,
  lact ? (type == "amd"),
  extraPackages ? [ ],
}:
let
  type' = util.assertMsg (builtins.elem type [
    "intel"
    "amd"
  ]) type "invalid graphics type";
in
{
  hardware.graphics = {
    enable = true;
    enable32Bit = true;

    extraPackages =
      lib.optionals (type' == "intel") (
        with pkgs;
        [
          intel-media-driver
        ]
      )
      ++ extraPackages;
  };

  services.lact.enable = lact;
  hardware.amdgpu.overdrive.enable = (type' == "amd");
}
