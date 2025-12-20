{ config, pkgs, ... }:

{
  # OldUser101 sway configuration

  wayland.windowManager.sway = {
    enable = true;
    wrapperFeatures.gtk = true;

    config = rec {
      modifier = "Mod4";
      terminal = "kitty";

      startup = [
        { command = "kitty"; }
      ];

      input = {
        "type:keyboard" = {
          xkb_layout = "gb";
        };
      };
    };
  };
}
