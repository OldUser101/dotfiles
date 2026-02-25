{ pkgs, config, lib, ... }:

with lib;
let
  cfg = config.olduser101.htop;
in {
  options.olduser101.htop = {
    enable = mkOption {
      type = types.bool;
      default = true;
      description = "Enable htop";
    };

    showSwap = mkOption {
      type = types.bool;
      default = true;
      description = "Display swap usage if this system has swap";
    };

    showBattery = mkOption {
      type = types.bool;
      default = true;
      description = "Display battery capacity if this system has a battery";
    };
  };

  config = mkIf cfg.enable {
    programs.htop = {
      enable = true;

      settings = {
        show_cpu_frequency = true;
        show_cpu_temperature = true;

        tree_view = 1;
      } // (with config.lib.htop; leftMeters (
        [
          (bar "LeftCPUs")
          (bar "Memory")
        ]
        ++ optional cfg.showSwap (bar "Swap")
        ++ optional cfg.showBattery (text "Battery")
      )) // (with config.lib.htop; rightMeters [
        (bar "RightCPUs")
        (text "Tasks")
        (text "LoadAverage")
        (text "Uptime")
      ]);
    };
  };
}
