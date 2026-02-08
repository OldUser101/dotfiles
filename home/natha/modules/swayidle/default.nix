{ pkgs, config, lib, ... }:

with lib;
let
  cfg = config.olduser101.swayidle;
in {
  options.olduser101.swayidle = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable swayidle";
    };

    screenLocker = mkOption {
      type = types.str;
      default = "${pkgs.swaylock}/bin/swaylock";
      description = "Screen locker to run on sleep";
    };
  };

  config = mkIf cfg.enable {
    services.swayidle = {
      enable = true;

      events = {
        before-sleep = cfg.screenLocker;
      };
    };
  };
}
