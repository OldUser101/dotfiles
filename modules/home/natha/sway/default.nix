{
  pkgs,
  config,
  lib,
  ...
}:

with lib;
let
  cfg = config.olduser101.sway;

  grim = "${pkgs.grim}/bin/grim";
  slurp = "${pkgs.slurp}/bin/slurp";
  wl-copy = "${pkgs.wl-clipboard}/bin/wl-copy";
  swaybg = "${pkgs.swaybg}/bin/swaybg";
  brightnessctl = "${pkgs.brightnessctl}/bin/brightnessctl";
  wpctl = "${pkgs.wireplumber}/bin/wpctl";
in
{
  options.olduser101.sway = {
    enable = mkOption {
      type = types.bool;
      default = true;
      description = "Enable sway";
    };

    screenLocker = mkOption {
      type = types.nullOr types.str;
      default = "${pkgs.swaylock}/bin/swaylock";
      description = "Screen locker to be used by sway";
    };

    autoStart = mkOption {
      type = types.listOf types.str;
      default = [
        "${pkgs.alacritty}/bin/alacritty"
      ];
      description = "Commands to run on startup";
    };

    screenshotDirectory = mkOption {
      type = types.externalPath;
      default = "${config.home.homeDirectory}/pictures";
      description = "Screenshot directory";
    };

    recordingsDirectory = mkOption {
      type = types.externalPath;
      default = "${config.home.homeDirectory}/videos";
      description = "Recordings directory";
    };

    outputs = mkOption {
      type = types.attrs;
      default = { };
      description = "Display output properties";
    };

    extraInput = mkOption {
      type = types.attrs;
      default = { };
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
        terminal = "${pkgs.alacritty}/bin/alacritty";

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
        }
        // cfg.extraInput;

        seat = {
          "*" = {
            xcursor_theme = "Adwaita 24";
          };
        };

        gaps.inner = 15;

        window = {
          border = 2;
          titlebar = false;
        };

        colors = {
          focused = {
            background = "#1e1e2e";
            border = "#cba6f7";
            childBorder = "#cba6f7";
            indicator = "#cba6f7";
            text = "#ffffff";
          };

          focusedInactive = {
            background = "#1e1e2e";
            border = "#00000000";
            childBorder = "#00000000";
            indicator = "#00000000";
            text = "#ffffff";
          };

          unfocused = {
            background = "#1e1e2e";
            border = "#00000000";
            childBorder = "#00000000";
            indicator = "#00000000";
            text = "#ffffff";
          };

          urgent = {
            background = "#1e1e2e";
            border = "#f38ba8";
            childBorder = "#f38ba8";
            indicator = "#f38ba8";
            text = "#ffffff";
          };
        };

        focus.followMouse = "always";

        output = cfg.outputs;

        keybindings =
          let
            mod = config.wayland.windowManager.sway.config.modifier;
            src = ./.;
            screenshot = "${cfg.screenshotDirectory}/Screenshot_$(date +%F_%T).png";
          in
          {
            "${mod}+Shift+e" = "exit";
            "${mod}+Return" = "exec ${terminal}";
            "${mod}+F" = "exec ${pkgs.firefox}/bin/firefox";

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

            "${mod}+h" = "focus left";
            "${mod}+j" = "focus down";
            "${mod}+k" = "focus up";
            "${mod}+l" = "focus right";

            "${mod}+comma" = "exec ${cfg.screenLocker}";

            "${mod}+F11" = "fullscreen toggle";
            "${mod}+Shift+F" = "floating toggle";

            "${mod}+Shift+S" = "exec ${grim} - | ${wl-copy}";
            "Shift+S" = "exec ${grim} -g \"$(${slurp})\" - | ${wl-copy}";
            "${mod}+S" = "exec ${grim} -g \"$(${slurp})\" ${screenshot}";

            "${mod}+C" = "exec /usr/bin/env OUT_DIR=${cfg.recordingsDirectory} ${src}/helpers/record-output.sh";

            "${mod}+space" = "exec ${pkgs.wofi}/bin/wofi --show drun";

            "XF86MonBrightnessUp" = "exec ${brightnessctl} set 5%+";
            "XF86MonBrightnessDown" = "exec ${brightnessctl} set 5%-";

            "XF86AudioRaiseVolume" = "exec ${wpctl} set-volume @DEFAULT_AUDIO_SINK@ 5%+";
            "XF86AudioLowerVolume" = "exec ${wpctl} set-volume @DEFAULT_AUDIO_SINK@ 5%-";
            "XF86AudioMute" = "exec ${wpctl} set-mute @DEFAULT_AUDIO_SINK@ toggle";
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

        bars = [ ];
      };

      # No better equivalent for `bindgesture`, manually done here
      extraConfig =
        let
          src = ./.;
        in
        ''
          bindgesture swipe:left exec ${src}/helpers/next-workspace.sh
          bindgesture swipe:right exec ${src}/helpers/prev-workspace.sh
          swaybg_command ${swaybg}
        '';
    };

    # May depend on external files not present when building,
    # don't validate config.
    wayland.windowManager.sway.checkConfig = false;

    home.packages = with pkgs; [
      jq
      wf-recorder
    ];

    home.pointerCursor = {
      gtk.enable = true;
      package = pkgs.adwaita-icon-theme;
      name = "Adwaita";
      size = 24;
    };

    home.file.".XCompose".source = ./xcompose;
  };
}
