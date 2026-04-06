{
  pkgs,
  config,
  lib,
  ...
}:

with lib;
let
  cfg = config.olduser101.fs;
in
{
  imports = [ ./swap ];

  options.olduser101.fs = {
    type = mkOption {
      type = types.enum [
        "efi-default"
        "efi-baytrail"
        "bios-default"
      ];
      description = "Filesystem configuration type";
    };
  };

  config =
    let
      fsConfig = mkMerge [
        (mkIf (cfg.type == "efi-default") {
          fileSystems."/" = {
            device = "/dev/disk/by-partlabel/ROOT";
            fsType = "btrfs";
          };

          fileSystems."/boot" = {
            device = "/dev/disk/by-partlabel/ESP";
            fsType = "vfat";
            options = [
              "fmask=0077"
              "dmask=0077"
            ];
          };

          fileSystems."/home" = {
            device = "/dev/disk/by-partlabel/DATA";
            fsType = "btrfs";
            options = [
              "subvol=home"
              "compress=zstd:1"
              "noatime"
            ];
          };
        })

        (mkIf (cfg.type == "efi-baytrail") {
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

        (mkIf (cfg.type == "bios-default") {
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
      ];
    in
    fsConfig;
}
