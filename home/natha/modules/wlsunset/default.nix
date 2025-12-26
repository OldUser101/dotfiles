{ pkgs, config, lib, ... }:

with lib;
let
  cfg = config.olduser101.wlsunset;
in {
  options.olduser101.wlsunset = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable wlsunset";
    };

    latitude = mkOption {
      type = types.str;
      default = "51.5287398"; # default to central London
      description = "Latitude for set location";
    };

    longitude = mkOption {
      type = types.str;
      default = "-0.2664017";  # default to central London
      description = "Longitude for set location";
    };
  };

  config = mkIf cfg.enable {
    services.wlsunset = {
      enable = true;
      
      latitude = cfg.latitude;
      longitude = cfg.longitude;
    };
  };
}
