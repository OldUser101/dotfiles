{
  pkgs,
  config,
  lib,
  ...
}:

with lib;
let
  cfg = config.olduser101.way-edges;
in
{
  options.olduser101.way-edges = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable way-edges configuration";
    };

    systemd = mkOption {
      type = types.bool;
      default = true;
      description = "Enable SystemD service for way-edges";
    };

    battery = mkOption {
      type = types.bool;
      default = false;
      description = "Enable battery display";
    };
  };

  config = mkIf cfg.enable {
    programs.way-edges = {
      enable = true;
      package = pkgs.way-edges;
      settings = {
        widgets = [
          {
            ignore-exclusive = true;
            edge = "top";
            position = "left";
            monitor = "*";
            layer = "overlay";
            type = "wrap-box";
            outlook = {
              type = "window";
              color = "#cba6f7";
              bg-color = "#1e1e2e";
              border-radius = 0;
              border-width = 2;
              margins = {
                top = 5;
                left = 5;
                right = 5;
                bottom = 5;
              };
            };
            items = [
              {
                type = "text";
                fg-color = "#f9e2af";
                font-size = 12;
                font-family = "Fira Code Nerd Font";
                preset = {
                  type = "time";
                  format = "%a %b %d %H:%M";
                  update-interval = 500;
                };
              }
            ]
            ++ (lib.optional cfg.battery [
              {
                type = "ring";
                fg-color = "#a6e3a1";
                suffix = "{float:0,100}%";
                font-family = "Fira Code Nerd Font";
                preset = {
                  type = "battery";
                  update-interval = 500;
                };
              }
            ]);
          }
        ];
      };
    };

    systemd.user.services.way-edges = mkIf cfg.systemd {
      Unit = {
        Description = "way-edges";
        After = [ "graphical-session.target" ];
        PartOf = [ "graphical-session.target" ];
        ConditionEnvironment = "WAYLAND_DISPLAY";
        X-Reload-Triggers = optional (
          config.programs.way-edges.settings != { }
        ) "${config.xdg.configFile."way-edges/config.jsonc".source}";
      };

      Service = {
        ExecStart = "${pkgs.way-edges}/bin/way-edges";
        Restart = "on-failure";
      };

      Install = {
        WantedBy = [ "graphical-session.target" ];
      };
    };
  };
}
