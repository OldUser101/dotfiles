{ pkgs, config, lib, ... }:

with lib;
let
  cfg = config.olduser101.security.sudo;
in {
  options.olduser101.security.sudo = {
    enable = mkOption {
      type = types.bool;
      default = true;
      description = "Enablesudo configuration";
    };
  };

  config = mkIf cfg.enable {
    security.sudo.extraConfig = ''
      Defaults insults
    '';
  };
}
