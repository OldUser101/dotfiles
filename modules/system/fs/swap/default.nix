{
  lib,
  util,
  ...
}:
{
  type,
}:
let
  type' = util.assertMsg (builtins.elem type [ "partition" ]) type "invalid swap type";
in
lib.mkMerge [
  (lib.mkIf (type' == "partition") {
    swapDevices = [
      {
        device = "/dev/disk/by-label/SWAP";
        options = [
          "defaults"
          "nofail"
        ];
        discardPolicy = "once";
      }
    ];
  })
]
