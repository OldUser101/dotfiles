{ pkgs, config, lib, ... }:

with lib;
let
  cfg = config.olduser101.natha.waybar;
in {
  options.olduser101.natha.waybar = {
    enableStyles = mkOption {
      type = types.bool;
      default = false;
      description = "Enable optional waybar styles";
    };
  };

  config = mkIf cfg.enableStyles {
    programs.waybar.style = ./style.css;
  };
}
