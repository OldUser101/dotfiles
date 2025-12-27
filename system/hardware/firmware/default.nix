{ pkgs, config, lib, ... }:

with lib;
let
  cfg = config.olduser101.hardware.firmware;
in {
  options.olduser101.hardware.firmware = {
    enable = mkOption {
      type = types.bool;
      default = true;
      description = "Enable firmware configuration";
    };
  };

  config = mkIf cfg.enable {
    hardware.enableAllFirmware = mkDefault true;
    hardware.enableRedistributableFirmware = mkDefault true;
    hardware.cpu.intel.updateMicrocode = mkDefault true;
    hardware.cpu.amd.updateMicrocode = mkDefault true;
  };
}
