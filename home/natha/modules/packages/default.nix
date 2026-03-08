{
  pkgs,
  config,
  lib,
  ...
}:

with lib;
let
  cfg = config.olduser101.packages;

  # https://github.com/NixOS/nixpkgs/issues/493843#issuecomment-3956990127
  calibre_fix = pkgs.calibre.overrideAttrs (old: {
    installPhase = ''
      export QMAKE="${pkgs.qt6.qtbase}/bin/qmake"
    ''
    + old.installPhase;
  });
in
{
  options.olduser101.packages = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable optional extra packages";
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

  config = mkIf cfg.enable {
    home.packages =
      with pkgs;
      [
        # C/C++
        gcc

        # Misc
        calibre_fix
        delta
        discord
        firefoxpwa
        fnm
        jujutsu
        lic

        # One needs an office suite sometimes
        libreoffice-qt-fresh

        # Nix
        nil
        nixfmt

        # Python
        python3

        # Util
        brightnessctl
        pavucontrol
      ]
      ++ optionals cfg.enableGames [
        dhewm3
        gzdoom
        prismlauncher
        nethack
        unnethack
      ]
      ++ cfg.extraPackages;

    home.file."${config.home.homeDirectory}/.nethackrc".source = ./nethack/.nethackrc;
  };
}
