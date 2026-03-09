{
  pkgs,
  config,
  lib,
  ...
}:

with lib;
let
  cfg = config.olduser101.zellij;
in
{
  options.olduser101.zellij = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable zellij configuration";
    };
  };

  config = mkIf cfg.enable {
    programs.zellij = {
      enable = true;
      settings = {
        theme = "catppuccin-mocha";
        show_startup_tips = false;
        default_layout = "compact";
      };
    };
  };
}
