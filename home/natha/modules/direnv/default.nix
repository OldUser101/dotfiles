{ pkgs, config, lib, ... }:

with lib;
let
  cfg = config.olduser101.direnv;
in {
  options.olduser101.direnv = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable direnv";
    };
  };

  config = mkIf cfg.enable {
    programs.direnv = {
      enable = true;
      enableZshIntegration = true;
      nix-direnv.enable = true;
    };
  };
}
