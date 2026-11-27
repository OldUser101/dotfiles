{
  pkgs,
  config,
  lib,
  ...
}:

with lib;
let
  cfg = config.olduser101.fuzzel;
in
{
  options.olduser101.fuzzel = {
    enable = mkOption {
      type = types.bool;
      default = true;
      description = "Enable fuzzel";
    };

    mango = mkOption {
      type = types.bool;
      default = config.olduser101.mango.enable;
      description = "Enable Mango integration";
    };

    sway = mkOption {
      type = types.bool;
      default = config.olduser101.sway.enable;
      description = "Enable Sway integration";
    };
  };

  config = mkIf cfg.enable {
    olduser101.mango = mkIf cfg.mango {
      extraConfig = ''
        bindo=SUPER,Space,spawn,${pkgs.fuzzel}/bin/fuzzel
      '';
    };

    olduser101.sway = mkIf cfg.sway {
      extraConfig = ''
        bindsym --no-repeat ${config.wayland.windowManager.sway.config.modifier}+space exec ${pkgs.fuzzel}/bin/fuzzel
      '';
    };

    programs.fuzzel = {
      enable = true;
      settings = {
        main = {
          font = "Fira Code Nerd Font,monospace";
          use-bold = true;
          prompt = "\"→ \""; # extra quotes needed to stop the space being cut off
          width = 70;
          tabs = 4;
          horizontal-pad = 8;
          vertical-pad = 8;
          inner-pad = 8;
        };
        colors = {
          background = "1e1e2eff";
          text = "cdd6f4ff";
          message = "cdd6f4ff";
          prompt = "cdd6f4ff";
          input = "cdd6f4ff";
          match = "cdd6f4ff";
          selection = "cba6f7ff";
          selection-text = "1e1e2eff";
          selection-match = "1e1e2eff";
          border = "cba6f7ff";
        };
        border = {
          width = 2;
          radius = 0;
        };
      };
    };
  };
}
