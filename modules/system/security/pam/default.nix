{ pkgs, config, lib, ... }:

with lib;
let
  cfg = config.olduser101.security.pam;
in {
  options.olduser101.security.pam = {
    enable = mkOption {
      type = types.bool;
      default = true;
      description = "Enable PAM configuration";
    };

    services = mkOption {
      type = types.listOf types.str;
      default = [ ];
      description = "PAM services list";
    };
  };

  config = mkIf cfg.enable {
    security.pam.services = listToAttrs (map (s: {
      name = s; value = {};
    }) cfg.services);
  };
}
