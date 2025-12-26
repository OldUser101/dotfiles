{ pkgs, config, lib, ... }:

with lib;
let
  cfg = config.olduser101.hardware.graphics;
in {
  options.olduser101.hardware.graphics = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable graphics configuration";
    };

    type = mkOption {
      type = types.enum [ "intel" ];
      description = "GPU \"type\"";
    };

    extraPackages = mkOption {
      type = types.listOf types.package;
      default = [ ];
      description = "Extra graphics packages to install";
    };
  };

  config = mkIf cfg.enable {
    hardware.graphics = {
      enable = true;

      extraPackages =
        optionals (cfg.type == "intel") ( with pkgs; [
          intel-media-driver
        ])
        ++ cfg.extraPackages;
    };
  };
}
