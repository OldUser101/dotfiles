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

    sway_workspaces = mkOption {
      type = types.bool;
      default = true;
      description = "Enable sway workspace module";
    };

    style = mkOption {
      type = types.nullOr types.pathWith;
      default = null;
      description = "CSS file for waybar styling";
    };
  };

  config = mkIf cfg.enable {
    programs.waybar = {
      enable = true;

      settings = {
        mainBar = {
          layer = "top";
          modules-left = optional cfg.sway_workspaces [ "sway/workspaces" ];
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
        } // mkIf cfg.sway_workspaces {
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
