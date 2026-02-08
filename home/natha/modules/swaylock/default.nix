{ pkgs, config, lib, ... }:

with lib;
let
  cfg = config.olduser101.swaylock;
in {
  options.olduser101.swaylock = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable swaylock";
    };
  };

  config = mkIf cfg.enable {
    programs.swaylock = {
      enable = true;
      settings = {
        color = "1e1e2e";
        show-failed-attempts = true;
      };
    };
  };
}
