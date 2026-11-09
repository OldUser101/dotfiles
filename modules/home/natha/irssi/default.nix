{
  pkgs,
  config,
  lib,
  ...
}:

with lib;
let
  cfg = config.olduser101.irssi;
in
{
  options.olduser101.irssi = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable irssi";
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      irssi
    ];

    home.file.".irssi/catppuccin.theme".source = ./themes/catppuccin.theme;
    home.file.".irssi/scripts/autorun/mouse.pl".source = ./scripts/mouse.pl;
    home.file.".irssi/scripts/autorun/winnum.pl".source = ./scripts/winnum.pl;
  };
}
