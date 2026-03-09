{
  pkgs,
  config,
  lib,
  ...
}:

with lib;
let
  cfg = config.olduser101.alacritty;
in
{
  options.olduser101.alacritty = {
    enable = mkOption {
      type = types.bool;
      default = true;
      description = "Enable alacritty configuration";
    };
  };

  config = mkIf cfg.enable {
    programs.alacritty = {
      enable = true;
      theme = "catppuccin_mocha";
      settings = {
        colors = {
          selection = {
            text = "#f9e2af";
            background = "#454145";
          };
          cursor.cursor = "#f9e2af";
        };
        window.padding = {
          x = 15;
          y = 15;
        };
        font.normal = {
          family = "Fira Code Nerd Font";
          style = "Regular";
        };
        cursor.style = {
          shape = "Block";
          blinking = "On";
        };
      };
    };
  };
}
