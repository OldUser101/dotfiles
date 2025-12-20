{ config, pkgs, ... }:

{
  # OldUser101 waybar configuration

  programs.waybar = {
    enable = true;

    settings = {
      mainBar = {
        layer = "top";
        modules-left = [ "sway/workspaces" ];
        modules-center = [ "clock" ];
        modules-right = [ "network" "battery" ];

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
          format-icons = [ "" "" "" "" "" ];
          tooltip = false;
        };
      };
    };

    style =
    let
      src = ./.;
    in
      /${src}/style.css;
  };
}
