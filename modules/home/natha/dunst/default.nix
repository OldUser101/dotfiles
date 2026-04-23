{
  pkgs,
  config,
  lib,
  ...
}:

with lib;
let
  cfg = config.olduser101.dunst;
in
{
  options.olduser101.dunst = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable dunst";
    };
  };

  config = mkIf cfg.enable {
    services.dunst = {
      enable = true;
      settings = {
        global = {
          font = "Fira Code 10";
          padding = 10;
          gap_size = 13;
          frame_width = 2;
          frame_color = "#cba6f7";
          transparency = 15;
        };

        urgency_low = {
          background = "#1e1e2e";
          foreground = "#cdd6f4";
          timeout = 5;
        };

        urgency_normal = {
          background = "#1e1e2e";
          foreground = "#cdd6f4";
          timeout = 10;
        };

        urgency_critical = {
          background = "#1e1e2e";
          foreground = "#cdd6f4";
          timeout = 0;
        };
      };
    };
  };
}
