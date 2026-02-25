{ pkgs, config, lib, ... }:

with lib;
let
  cfg = config.olduser101.hardware.bluetooth;
in {
  options.olduser101.hardware.bluetooth = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable Bluetooth configuration";
    };

    extraSettings = mkOption {
      type = types.attrs;
      default = { };
      description = "Additional Bluetooth settings";
    };
  };

  config = mkIf cfg.enable {
    hardware.bluetooth = {
      enable = true;
      powerOnBoot = true;
      settings = mkMerge [
        {
          General = {
            Experimental = true;
            FastConnectable = true;
          };

          Policy = {
            AutoEnable = true;
          };
        }
        cfg.extraSettings
      ];
    };
  };
}
