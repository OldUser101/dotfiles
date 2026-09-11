{
  pkgs,
  config,
  lib,
  ...
}:

with lib;
let
  cfg = config.olduser101.packages;

  _nethack = pkgs.nethack.overrideAttrs (old: {
    postPatch = ''
      echo "WIZARDS=*" >> sys/unix/sysconf
    ''
    + old.postPatch;
  });
in
{
  options.olduser101.packages = {
    type = mkOption {
      type = types.enum [
        "minimal"
        "full"
        "server"
      ];
      default = "minimal";
      description = "Types of extra packages to install";
    };

    enableGames = mkOption {
      type = types.bool;
      default = false;
      description = "Enable optional games";
    };

    extraPackages = mkOption {
      type = types.listOf types.package;
      default = [ ];
      description = "(even more) extra packages to install";
    };
  };

  config = {
    home.packages =
      with pkgs;
      [ ]
      ++ (optionals (cfg.type == "server") [
        nixfmt
        python3
        man-pages
        cachix
        nil
        unzip
      ])
      ++ (optionals (cfg.type == "minimal" || cfg.type == "full") [
        # Nix
        nixfmt

        # Python
        python3

        # Util
        brightnessctl
        pavucontrol
        wl-clipboard

        # man pages
        man-pages
        man-pages-posix
      ])
      ++ (optionals (cfg.type == "full") [
        # C/C++
        gcc

        # Misc
        calibre
        delta
        firefoxpwa
        jujutsu
        mpv
        lic
        gh
        unzip
        onyx

        # One needs an office suite sometimes
        libreoffice-qt-stable

        # Nix
        cachix
        nil
      ])
      ++ optionals cfg.enableGames [
        dhewm3
        gzdoom
        prismlauncher
        _nethack
        unnethack
      ]
      ++ cfg.extraPackages;

    programs.firefox.nativeMessagingHosts = mkIf (cfg.type == "full") [ pkgs.firefoxpwa ];

    home.file."${config.home.homeDirectory}/.nethackrc".source = ./.nethackrc;
    home.file."${config.home.homeDirectory}/.unnethackrc".source = ./.unnethackrc;

    xdg.configFile."jj/config.toml".text = ''
      [signing]
      behavior="own"
      backend="ssh"
      key="ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICeXZ8vRxqvcxCaOehuxN50MoTp5b7UNRIsn9FvW327x"

      [user]
      name = "Nathan Gill"
      email = "n@ngill.net"

      [ui]
      editor = "kak" # use kakoune from environment
      default-command = "log"
      pager = "${pkgs.less}/bin/less -FR --mouse"

      [templates]
      git_push_bookmark = '"OldUser101/push-" ++ change_id.short()'
    '';
  };
}
