{ pkgs, config, lib, ... }:

with lib;
let
  cfg = config.olduser101.fs.swap;
in {
  options.olduser101.fs.swap = {
    enable = mkOption {
      type = types.bool;
      default = true;
      description = "Enable swap configuration";
    };

    type = mkOption {
      type = types.enum [ "partition" ];
      description = "Swap types";
    };
  };

  config =
    let
      swapConfig = mkMerge [
        (mkIf (cfg.type == "partition") {
          swapDevices = [
            {
              device = "/dev/disk/by-partlabel/SWAP";
              options = [ "defaults" "nofail" ];
              discardPolicy = "once";
            }
          ];
        })
      ];
    in
    mkIf cfg.enable swapConfig;
}
