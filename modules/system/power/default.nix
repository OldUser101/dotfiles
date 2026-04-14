{
  pkgs,
  config,
  lib,
  ...
}:

with lib;
let
  cfg = config.olduser101.power;
in
{
  options.olduser101.power = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable power management configuration";
    };

    profile = mkOption {
      type = types.enum [ "laptop" ];
      description = "Power profile to use on this host";
    };
  };

  config =
    let
      powerConfig = mkIf cfg.enable (mkMerge [
        (mkIf (cfg.profile == "laptop") {
          services.thermald.enable = true;
          services.tlp.enable = true;
        })
      ]);
    in
    powerConfig;
}
