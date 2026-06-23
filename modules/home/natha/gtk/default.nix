{
  pkgs,
  config,
  lib,
  ...
}:

with lib;
let
  cfg = config.olduser101.gtk;

  catppuccinGtk = pkgs.catppuccin-gtk.override {
    accents = [ "mauve" ];
    variant = "mocha";
  };
in
{
  options.olduser101.gtk = {
    enable = mkOption {
      type = types.bool;
      default = true;
      description = "Enable GTK configuration";
    };

    themePackage = mkOption {
      type = types.package;
      default = catppuccinGtk;
      description = "GTK theme package";
    };
  };

  config = mkIf cfg.enable {
    gtk = {
      enable = true;
      theme.package = cfg.themePackage;
      theme.name = "catppuccin-mocha-mauve-standard";
      gtk4.theme.package = cfg.themePackage;
      gtk4.theme.name = "catppuccin-mocha-mauve-standard";
    };
  };
}
