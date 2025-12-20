{ config, pkgs, ... }:

{
  # OldUser101 dunst configuration

  services.dunst = {
    enable = true;
    settings = {
      global = {
        font = "Fira Code 10";
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
}
