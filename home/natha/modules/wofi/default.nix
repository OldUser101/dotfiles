{
  pkgs,
  config,
  lib,
  ...
}:

with lib;
let
  cfg = config.olduser101.wofi;
in
{
  options.olduser101.wofi = {
    enable = mkOption {
      type = types.bool;
      default = true;
      description = "Enable wofi";
    };

    style = mkOption {
      type = types.nullOr types.path;
      default = ./style.css;
      description = "CSS stylesheet for wofi";
    };
  };

  config = mkIf cfg.enable {
    programs.wofi = {
      enable = true;
      style = optionals (cfg.style != null) (builtins.readFile cfg.style);
    };
  };
}
