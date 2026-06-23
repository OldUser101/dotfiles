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
      platformTheme.name = "adwaita";
      platformTheme.package = [
        pkgs.adwaita-qt
        pkgs.adwaita-qt6
      ];
      style.name = "adwaita-dark";
    };
  };
}
