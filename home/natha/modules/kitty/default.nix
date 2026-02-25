{ pkgs, config, lib, ... }:

with lib;
let
  cfg = config.olduser101.kitty;
in {
  options.olduser101.kitty = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable kitty";
    };

    enableRemoteControl = mkOption {
      type = types.bool;
      default = false;
      description = "Enable kitty remote terminal control";
    };
  };

  config = mkIf cfg.enable {
    programs.kitty = {
      enable = true;

      settings = {
        # Colours
        foreground = "#cdd6f4";
        background = "#1e1e2e";
        selection_foreground = "#f9e2af";
        selection_background = "#454145";

        cursor = "#f9e2af";
        cursor_text_color = "#1e1e2e";

        mark1_foreground = "#1e1e2e";
        mark1_background = "#b4befe";
        mark2_foreground = "#1e1e2e";
        mark2_background = "#cba6f7";
        mark3_foreground = "#1e1e2e";
        mark3_background = "#74c7ec";

        color0 = "#45475a";
        color8 = "#585b70";

        color1 = "#f38ba8";
        color9 = "#f38ba8";

        color2 = "#a6e3a1";
        color10 = "#a6e3a1";

        color3 = "#f9e2af";
        color11 = "#f9e2af";

        color4 = "#89b4fa";
        color12 = "#89b4fa";

        color5 = "#f5c2e7";
        color13 = "#f5c2e7";

        color6 = "#94e2d5";
        color14 = "#94e2d5";

        color7 = "#bac2de";
        color15 = "#a6adc8";

        # Misc. styles
        font_family = "Fira Code Nerd Font";
        font_size = "12.0";

        window_padding_width = "10";

        tab_bar_edge = "top";
        tab_bar_style = "powerline";

        allow_remote_control = if cfg.enableRemoteControl then "yes" else "no";

        # Layouts
        enabled_layouts = "splits";
      };

      keybindings = {
        "shift+f4" = "launch --location=split";
        "shift+f5" = "launch --location=hsplit";
        "shift+f6" = "launch --location=vsplit";
        "shift+f7" = "layout_action rotate";

        "alt+up" = "move_window up";
        "alt+down" = "move_window down";
        "alt+left" = "move_window left";
        "alt+right" = "move_window right";

        "ctrl+up" = "neighboring_window up";
        "ctrl+down" = "neighboring_window down";
        "ctrl+left" = "neighboring_window left";
        "ctrl+right" = "neighboring_window right";

        "ctrl+." = "layout_action bias 80";

        "ctrl+shift+up" = "resize_window taller";
        "ctrl+shift+down" = "resize_window shorter 3";
        "ctrl+shift+left" = "resize_window narrower";
        "ctrl+shift+right" = "resize_window wider";

        "ctrl+shift+home" = "resize_window reset";
      };
    };
  };
}
