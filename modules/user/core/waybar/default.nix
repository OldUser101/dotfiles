{ pkgs, config, lib, ... }:

with lib;
let
  cfg = config.olduser101.waybar;
in {
  options.olduser101.waybar = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable waybar";
    };

    style = mkOption {
      type = types.nullOr types.pathWith;
      default = ./style.css;
      description = "CSS file for waybar styling";
    };
  };

  config = mkIf cfg.enable {
    programs.waybar = {
      enable = true;

      settings = {
        mainBar = {
          layer = "top";
          modules-left = optional cfg.swayWorkspaces [ "sway/workspaces" ];
          modules-center = [ "clock" ];
          modules-right = [ "network" "battery" ];

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
            format-icons = [ "" "" "" "" "" ];
            tooltip = false;
          };
        } // mkIf cfg.swayWorkspaces {
          "sway/workspaces" = {
            disable-scroll = true;
          };
        };
      };
    } // mkIf (cfg.style != null) {
      style = cfg.style;
    };
  };
}
