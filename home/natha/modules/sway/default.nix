{ pkgs, config, lib, ... }:

with lib;
let
  cfg = config.olduser101.sway;
in {
  options.olduser101.sway = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable sway";
    };

    screenLocker = mkOption {
      type = types.nullOr types.str;
      default = "swaylock";
      description = "Screen locker to be used by sway";
    };

    autoStart = mkOption {
      type = types.listOf types.str;
      default = [ "kitty" "waybar" ];
      description = "Commands to run on startup";
    };

    screenshotDirectory = mkOption {
      type = types.externalPath;
      default = "${config.home.homeDirectory}/pictures";
      description = "Screenshot directory";
    };

    outputs = mkOption {
      type = types.attrs;
      default = {};
      description = "Display output properties";
    };

    extraInput = mkOption {
      type = types.attrs;
      default = {};
      description = "Extra input configuration values";
    };

    extraConfig = mkOption {
      type = types.str;
      default = "";
      description = "Extra configuration lines";
    };
  };

  config = mkIf cfg.enable {
    wayland.windowManager.sway = {
      enable = true;
      wrapperFeatures.gtk = true;

      config = rec {
        modifier = "Mod4";
        terminal = "kitty";

        startup = map (c: { command = c; }) cfg.autoStart;
        
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
        } // cfg.extraInput;

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

        output = cfg.outputs;

        keybindings = 
          let
            mod = config.wayland.windowManager.sway.config.modifier;
            src = ./.;
            screenshot = "${cfg.screenshotDirectory}/Screenshot_$(date +%F_%T).png";
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

            "Mod1+F4" = "kill";
            "${mod}+Q" = "kill";

            "${mod}+Shift+h" = "move left";
            "${mod}+Shift+j" = "move down";
            "${mod}+Shift+k" = "move up";
            "${mod}+Shift+l" = "move right";

            "${mod}+L" = "exec ${cfg.screenLocker}";

            "${mod}+F11" = "fullscreen toggle";
            "${mod}+Shift+F" = "floating toggle";

            "Print" = "exec grim - | wl-copy";
            "Shift+Print" = "exec grim -g \"$(slurp)\" - | wl-copy";
            "${mod}+Print" = "exec grim -g \"$(slurp)\" ${screenshot}";

            "${mod}+space" = "exec wofi --show drun";
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

    # May depend on external files not present when building,
    # don't validate config.
    wayland.windowManager.sway.checkConfig = false;

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
  };
}
