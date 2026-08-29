{
  pkgs,
  config,
  lib,
  ...
}:

with lib;
let
  cfg = config.olduser101.mango;

  grim = "${pkgs.grim}/bin/grim";
  slurp = "${pkgs.slurp}/bin/slurp";
  wl-copy = "${pkgs.wl-clipboard}/bin/wl-copy";
  wofi = "${pkgs.wofi}/bin/wofi";
  brightnessctl = "${pkgs.brightnessctl}/bin/brightnessctl";
  wpctl = "${pkgs.wireplumber}/bin/wpctl";
  src = ./.;
in
{
  options.olduser101.mango = {
    enable = mkOption {
      type = types.bool;
      default = true;
      description = "Enable mangowm configuration";
    };

    terminal = mkOption {
      type = types.nullOr types.str;
      default = "${pkgs.alacritty}/bin/alacritty";
      description = "Terminal to use";
    };

    screenLocker = mkOption {
      type = types.nullOr types.str;
      default = "${pkgs.nlock}/bin/nlock";
      description = "Screen locker to use";
    };

    autoStart = mkOption {
      type = types.listOf types.str;
      default = [ ];
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

    extraConfig = mkOption {
      type = types.str;
      default = "";
      description = "Extra configuration lines";
    };
  };

  config = mkIf cfg.enable {
    wayland.windowManager.mango = {
      inherit (cfg) extraConfig;

      enable = true;

      autostart_sh = strings.join "\n" (map (c: "${c} &") cfg.autoStart);

      settings = {
        scroller = {
          structs = 20;
          default_proportion = 0.9;
          focus_center = 0;
          prefer_center = 1;
          default_proportion_single = 1.0;
          proportion_preset = [
            0.5
            0.8
            1.0
          ];
        };

        edge_scroller = {
          pointer_focus = 1;
          focus_allow_speed = 0.0;
        };

        focus = {
          on_activate = 0;
          cross_monitor = 0;
          cross_tag = 0;
        };

        no_border_when_single = 0;
        sloppyfocus = 1;
        warpcursor = 1;
        enable_floating_snap = 0;
        cursor_size = 24;
        tag_gather = 1;

        repeat_rate = 25;
        repeat_delay = 600;
        numlockon = 0;
        xkb_rules = {
          layout = "gb";
          options = "compose:ralt";
        };

        trackpad_natural_scrolling = 1;
        swipe_min_threshold = 1;

        border_radius = 0;
        focused_opacity = 1.0;
        unfocused_opacity = 1.0;

        animations = 0;
        layer_animations = 0;
        animation_fade_in = 0;
        animation_fade_out = 0;

        gappih = 15;
        gappiv = 15;
        gappoh = 15;
        gappov = 15;

        borderpx = 2;
        rootcolor = "0x00000000";
        bordercolor = "0x00000000";
        dropcolor = "0x00000000";
        splitcolor = "0x00000000";
        focuscolor = "0xcba6f7ff";
        globalcolor = "0x00000000";
        urgentcolor = "0xf38ba800";
        scratchpadcolor = "0x00000000";
        overlaycolor = "0x00000000";
        maximizecolor = "0x00000000";

        tagrule = [
          "id:*,layout_name:scroller"
        ];

        circle_layout = [
          "scroller"
          "tile"
        ];

        bind = [
          "SUPER,r,reload_config"

          "SUPER,Space,spawn,${wofi} --show drun"
          "SUPER,Return,spawn,${cfg.terminal}"
          "SUPER,Comma,spawn,${cfg.screenLocker}"
          "SUPER,f,spawn,${pkgs.firefox}/bin/firefox"

          "SUPER+SHIFT,e,quit"
          "SUPER,q,killclient"

          "ALT,Tab,focusstack,next"
          "SUPER,Left,focusdir,left"
          "SUPER,Right,focusdir,right"
          "SUPER,Up,focusdir,up"
          "SUPER,Down,focusdir,down"

          "SUPER+SHIFT,Up,exchange_client,up"
          "SUPER+SHIFT,Down,exchange_client,down"
          "SUPER+SHIFT,Left,exchange_client,left"
          "SUPER+SHIFT,Right,exchange_client,right"

          "ALT,backslash,togglefloating"
          "ALT,a,togglemaximizescreen"
          "ALT,f,togglefullscreen"

          "ALT,e,set_proportion,1.0"
          "ALT,x,switch_proportion_preset"
          "ALT+SUPER+CTRL,Left,scroller_stack,left"
          "ALT+SUPER+CTRL,Right,scroller_stack,right"
          "ALT+SUPER+CTRL,Up,scroller_stack,up"
          "ALT+SUPER+CTRL,Down,scroller_stack,down"

          "SUPER,n,switch_layout"

          "ALT+SHIFT,Left,focusmon,left"
          "ALT+SHIFT,Right,focusmon,right"

          "CTRL+SHIFT,Up,movewin,+0,-50"
          "CTRL+SHIFT,Down,movewin,+0,+50"
          "CTRL+SHIFT,Left,movewin,-50,+0"
          "CTRL+SHIFT,Right,movewin,+50,+0"

          "CTRL+ALT,Up,resizewin,+0,-50"
          "CTRL+ALT,Down,resizewin,+0,+50"
          "CTRL+ALT,Left,resizewin,-50,+0"
          "CTRL+ALT,Right,resizewin,+50,+0"

          "ALT,Up,viewtoleft,0"
          "ALT,Down,viewtoright,0"

          "SUPER,c,spawn,/usr/bin/env OUT_DIR=${cfg.recordingsDirectory} ${src}/../sway/helpers/record-output.sh"
          "SUPER,s,spawn,${grim} -g \"$(${slurp})\" ${cfg.screenshotDirectory}/Screenshot_$(date +%F_%T).png"
          "SUPER+SHIFT,s,spawn,${grim} -g \"$(${slurp})\" - | ${wl-copy}"

          "NONE,XF86AudioLowerVolume,spawn,${wpctl} set-volume @DEFAULT_AUDIO_SINK@ 5%-"
          "NONE,XF86AudioRaiseVolume,spawn,${wpctl} set-volume @DEFAULT_AUDIO_SINK@ 5%+"
          "NONE,XF86AudioMute,spawn,${wpctl} set-mute @DEFAULT_AUDIO_SINK@ toggle"

          "NONE,XF86MonBrightnessDown,spawn,${brightnessctl} set 5%-"
          "NONE,XF86MonBrightnessUp,spawn,${brightnessctl} set 5%+"
        ];
      };
    };

    home.packages = with pkgs; [
      jq
      wf-recorder
    ];

    home.pointerCursor = {
      enable = true;
      gtk.enable = true;
      package = pkgs.adwaita-icon-theme;
      name = "Adwaita";
      size = 24;
    };

    home.file.".XCompose".source = ../sway/xcompose;

    home.sessionVariables = {
      _JAVA_AWT_WM_NONREPARENTING = 1;
    };
  };
}
