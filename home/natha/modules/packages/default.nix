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
    '' + old.postPatch;
  });
in
{
  options.olduser101.packages = {
    type = mkOption {
      type = types.enum [
        "minimal"
        "full"
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
      [
        # Web browser
        firefox

        # Nix
        nixfmt

        # Python
        python3

        # Util
        brightnessctl
        pavucontrol
      ]
      ++ (optionals (cfg.type == "full") [
        # C/C++
        gcc

        # Misc
        calibre
        delta
        discord
        firefoxpwa
        jujutsu
        mpv
        lic
        gh
        unzip

        # One needs an office suite sometimes
        libreoffice-qt-fresh

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
  };
}
