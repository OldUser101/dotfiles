{ pkgs, config, lib, ... }:

with lib;
let
  cfg = config.olduser101.wofi;
in {
  options.olduser101.wofi = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable wofi";
    };

    style = mkOption {
      type = types.nullOr types.pathWith;
      default = null;
      description = "CSS stylesheet for wofi";
    };
  };

  config = mkIf cfg.enable {
    programs.wofi = {
      enable = true;
    } // mkIf (cfg.style != null) {
      style = cfg.style;
    };
  };
}
