{ config, pkgs, ... }:

{
  # OldUser101 sway configuration

  imports = [
    # Outputs are defined in a separate file
    ./outputs.nix
  ];

  wayland.windowManager.sway = {
    enable = true;
    wrapperFeatures.gtk = true;

    config = rec {
      modifier = "Mod4";
      terminal = "kitty";

      startup = [
        { command = "kitty"; }
        { command = "waybar"; }
      ];

      input = {
        "type:keyboard" = {
          xkb_layout = "gb";
          xkb_options = "compose:ralt";
        };

        "type:mouse" = {
          middle_emulation = "disabled";
        };

        "type:touchpad" = {
          tap = "enabled";
          tap_button_map = "lrm";
          dwt = "enabled";
          dwtp = "enabled";
          natural_scroll = "enabled";
        };
      };

      seat = {
        "*" = {
          xcursor_theme = "Adwaita 24";
        };
      };

      window = {
        commands = [
          {
            command = "border none";
            criteria = {
              class = ".*";
            };
          }
        ];
      };

      keybindings = 
      let 
        mod = config.wayland.windowManager.sway.config.modifier;
        src = ./.;
        homeDir = config.home.homeDirectory;
        screenshot = "${config.home.homeDirectory}/pictures/Screenshot_$(date +%F_%T).png";
      in {
        "${mod}+Shift+e" = "exit";
        "${mod}+Return" = "exec kitty";
        "${mod}+F" = "exec firefox";

        "${mod}+Left" = "exec ${src}/helpers/prev-workspace.sh";
        "${mod}+Right" = "exec ${src}/helpers/next-workspace.sh";
        "${mod}+Shift+Left" = "exec ${src}/helpers/prev-move-workspace.sh";
        "${mod}+Shift+Right" = "exec ${src}/helpers/next-move-workspace.sh";

        "${mod}+r" = "mode resize";
        "${mod}+m" = "mode move_float";

        "${mod}+F4" = "kill";
        "${mod}+Q" = "kill";

        "${mod}+Shift+h" = "move left";
        "${mod}+Shift+j" = "move down";
        "${mod}+Shift+k" = "move up";
        "${mod}+Shift+l" = "move right";

        "${mod}+L" = "exec swaylock";

        "${mod}+F11" = "fullscreen toggle";
        "${mod}+Shift+F" = "floating toggle";

        "Print" = "exec grim - | wl-copy";
        "Shift+Print" = "exec grim -g \"$(slurp)\" - | wl-copy";
        "${mod}+Print" = "exec grim -g \"$(slurp)\" ${screenshot}";
      };

      modes = {
        resize = {
          "Left" = "resize shrink width 10 px or 10 ppt";
          "Right" = "resize grow width 10 px or 10 ppt";
          "Up" = "resize shrink height 10 px or 10 ppt";
          "Down" = "resize grow height 10 px or 10 ppt";

          "Return" = "mode default";
          "Escape" = "mode default";
        };

        move_float = {
          "Left" = "move left 50px";
          "Right" = "move right 50px";
          "Up" = "move up 50px";
          "Down" = "move down 50px";

          "Return" = "mode default";
          "Escape" = "mode default";
        };
      };

      bars = [];
    };

    # No better equivalent for `bindgesture`, manually done here
    extraConfig =
    let
      src = ./.;
    in
      "bindgesture swipe:left exec ${src}/helpers/next-workspace.sh\n
       bindgesture swipe:right exec ${src}/helpers/prev-workspace.sh";
  };

  home.packages = with pkgs; [
    grim
    jq
    slurp
    wl-clipboard
  ];

  home.pointerCursor = {
    gtk.enable = true;
    package = pkgs.adwaita-icon-theme;
    name = "Adwaita";
    size = 24;
  };
}
