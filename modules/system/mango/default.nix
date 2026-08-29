{
  pkgs,
  config,
  lib,
  ...
}:

with lib;
let
  cfg = config.olduser101.mango;
in
{
  options.olduser101.mango = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable the Mango window manager";
    };
  };

  config = mkIf cfg.enable {
    security.polkit.enable = true;
    programs.mango.enable = true;
  };
}
