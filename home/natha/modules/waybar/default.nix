{
  pkgs,
  config,
  lib,
  ...
}:

with lib;
let
  cfg = config.olduser101.waybar;
in
{
  options.olduser101.waybar = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable waybar";
    };

    style = mkOption {
      type = types.nullOr types.path;
      default = ./style.css;
      description = "CSS file for waybar styling";
    };
  };

  config = mkIf cfg.enable {
    programs.waybar = {
      enable = true;
      style = optionals (cfg.style != null) (builtins.readFile cfg.style);

      settings = {
        mainBar = {
          layer = "top";
          modules-left = [ "sway/workspaces" ];
          modules-center = [ "clock" ];
          modules-right = [
            "network"
            "battery"
          ];

          "sway/workspaces" = {
            disable-scroll = true;
          };

          "clock" = {
            format = "{:%a %b %d %H:%M}";
            tooltip = false;
          };

          "network" = {
            format-wifi = " ";
            format-disconnected = "";
            tooltip = false;
          };

          "battery" = {
            format = "{capacity}% {icon}";
            format-icons = [
              ""
              ""
              ""
              ""
              ""
            ];
            tooltip = false;
          };
        };
      };
    };
  };
}
