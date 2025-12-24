{ pkgs, config, lib, ... }:

with lib;
let
  cfg = config.olduser101.natha.wofi;
in {
  options.olduser101.natha.wofi = {
    enableStyles = mkOption {
      type = types.bool;
      default = false;
      description = "Enable optional wofi styles";
    };
  };

  config = mkIf cfg.enableStyles {
    programs.wofi = {
      style = ./style.css;
    };
  };
}
