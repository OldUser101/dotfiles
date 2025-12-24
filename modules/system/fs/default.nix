{ pkgs, config, lib, ... }:

with lib;
let
  cfg = config.olduser101.fs;
in {
  imports = [ ./swap ];
  
  options.olduser101.fs = {
    type = mkOption {
      type = types.enum [ "efi-default" ];
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
            options = [ "fmask=0077" "dmask=0077" ];
          };

          fileSystems."/home/natha" = {
            device = "/dev/disk/by-partlabel/DATA";
            fsType = "btrfs";
            options = [ "subvol=home/natha" "compress=zstd:1" "noatime" ];
          };
        })
      ];
    in
    fsConfig;
}
