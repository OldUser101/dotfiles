{ pkgs, config, lib, ... }:

with lib;
let
  cfg = config.olduser101.dunst;
in {
  options.olduser101.dunst = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable dunst";
    };

    font = mkOption {
      type = types.str;
      default = "Fira Code 10";
      description = "Notification font";
    };
  };

  config = mkIf cfg.enable {
    services.dunst = {
      enable = true;
      settings = {
        global = {
          font = cfg.font;
          padding = 10;
          frame_width = 2;
          transparency = 15;
        };

        urgency_low = {
          background = "#302d41";
          foreground = "#d9e0ee";
          timeout = 5;
        };

        urgency_normal = {
          background = "#403d52";
          foreground = "#d9e0ee";
          timeout = 10;
        };

        urgency_critical = {
          background = "#f28fad";
          foreground = "#1e1e2e";
          timeout = 0;
        };
      };
    };
  };
}
