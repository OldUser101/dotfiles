{
  pkgs,
  config,
  lib,
  ...
}:

with lib;
let
  cfg = config.olduser101.ghostty;

  themeFile = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/claymorwan/catppuccin/refs/heads/main/adw/themes/mocha/catppuccin-mocha-mauve.css";
    sha256 = "b23dfa60cbe4a51ca6e858334331ee1b42bc36afedfd11d3669c43741890c9b6";
  };

in
{
  options.olduser101.ghostty = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable ghostty terminal emulator";
    };
  };

  config = mkIf cfg.enable {
    programs.ghostty = {
      enable = true;
      settings = {
        theme = "Catppuccin Mocha";
        font-family = "Fira Code Nerd Font";
        font-size = 12;
        window-padding-x = 10;
        window-padding-y = 10;
        window-decoration = "client";
        gtk-titlebar-style = "tabs";
        focus-follows-mouse = true;
        mouse-shift-capture = "always";
        mouse-hide-while-typing = true;
        gtk-custom-css = "${themeFile}";
      };
    };
  };
}
