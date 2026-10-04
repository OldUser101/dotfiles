{
  pkgs,
  lib,
  util,
  modulesPath,
  config,
}:
{
  type,
  swap ? null,
  extraConfig ? { },
}:
let
  type' = util.assertMsg (builtins.elem type [
    "efi-default"
    "efi-unified"
    "efi-baytrail"
    "bios-default"
    "bios-sdafwca"
  ]) type "invalid filesystem type";
in
lib.mkMerge [
  (lib.mkIf (type' == "efi-default") {
    fileSystems."/" = {
      device = "/dev/disk/by-label/ROOT";
      fsType = "btrfs";
    };

    fileSystems."/boot" = {
      device = "/dev/disk/by-label/BOOT";
      fsType = "vfat";
      options = [
        "fmask=0077"
        "dmask=0077"
      ];
    };

    fileSystems."/home" = {
      device = "/dev/disk/by-label/HOME";
      fsType = "btrfs";
      options = [
        "subvol=home"
        "compress=zstd:1"
        "noatime"
      ];
    };
  })

  (lib.mkIf (type' == "efi-baytrail") {
    fileSystems."/" = {
      device = "/dev/disk/by-label/ROOT";
      fsType = "btrfs";
    };

    fileSystems."/boot" = {
      device = "/dev/disk/by-label/BOOT";
      fsType = "vfat";
      options = [
        "fmask=0077"
        "dmask=0077"
      ];
    };
  })

  (lib.mkIf (type' == "efi-unified") {
    fileSystems."/" = {
      device = "/dev/disk/by-label/ROOT";
      fsType = "btrfs";
    };

    fileSystems."/boot" = {
      device = "/dev/disk/by-label/BOOT";
      fsType = "vfat";
      options = [
        "fmask=0077"
        "dmask=0077"
      ];
    };
  })

  (lib.mkIf (type' == "bios-default") {
    fileSystems."/" = {
      device = "/dev/disk/by-label/ROOT";
      fsType = "ext4";
    };

    fileSystems."/boot" = {
      device = "/dev/disk/by-label/BOOT";
      fsType = "vfat";
      options = [
        "fmask=0022"
        "dmask=0022"
      ];
    };
  })

  (lib.mkIf (type' == "bios-sdafwca") {
    fileSystems."/" = {
      device = "/dev/disk/by-label/ROOT";
      fsType = "xfs";
    };

    fileSystems."/boot" = {
      device = "/dev/disk/by-label/BOOT";
      fsType = "ext4";
    };
  })

  (
    if (swap != null) then
      (
        (import ./swap {
          inherit
            pkgs
            lib
            util
            modulesPath
            config
            ;
        })
          swap
      )
    else
      { }
  )

  extraConfig
]
