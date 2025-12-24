{ pkgs, config, lib, ... }:

with lib;
let
  cfg = config.olduser101.shells.zsh;
in {
  options.olduser101.shells.zsh = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable zsh";
    };
  };

  config = mkIf cfg.enable {
    programs.zsh.enable = true;
    environment.pathsToLink = [ "/share/zsh" ];
  };
}
