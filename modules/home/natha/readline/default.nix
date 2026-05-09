{
  pkgs,
  config,
  lib,
  ...
}:

with lib;
let
  cfg = config.olduser101.readline;
in
{
  options.olduser101.readline = {
    enable = mkOption {
      type = types.bool;
      default = true;
      description = "Enable readline configuration";
    };
  };

  config = mkIf cfg.enable {
    programs.readline = {
      enable = true;
      extraConfig = ''
        set completion-ignore-case on
        set show-mode-in-prompt on
        set editing-mode vi
        set vi-ins-mode-string ""
        set vi-cmd-mode-string "\1\e[1;93m\2|\1\e[0m\2 "
      '';
    };
  };
}
