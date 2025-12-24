{ pkgs, config, lib, ... }:

with lib;
let
  cfg = config.olduser101.sway;
in {
  options.olduser101.sway = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable the Sway window manager";
    };
  };

  config = mkIf cfg.enable {
    security.polkit.enable = true;
    programs.sway.enable = true;
  };
}
