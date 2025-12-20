{ config, pkgs, ... }:

{
  # OldUser101 htop configuration

  programs.htop = {
    enable = true;

    settings = {
      show_cpu_frequency = 1;
      show_cpu_temperature = 1;

      tree_view = 1;
    } // (with config.lib.htop; leftMeters [
      (bar "LeftCPUs")
      (bar "Memory")
      (bar "Swap")
      (text "Battery")
    ]) // (with config.lib.htop; rightMeters [
      (bar "RightCPUs")
      (text "Tasks")
      (text "LoadAverage")
      (text "Uptime")
    ]);
  };
}
