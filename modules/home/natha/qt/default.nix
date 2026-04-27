{
  pkgs,
  config,
  lib,
  ...
}:

with lib;
let
  cfg = config.olduser101.qt;
in
{
  options.olduser101.qt = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Qt theme configuration";
    };
  };

  config = mkIf cfg.enable {
    qt = {
      enable = true;
      platformTheme.name = "qtct";
      style.name = "Fusion";
    };

    home.sessionVariables = {
      QT_QPA_PLATFORMTHEME = "qt5ct";
    };
  };
}
