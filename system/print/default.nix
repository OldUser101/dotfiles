{
  pkgs,
  config,
  lib,
  ...
}:

with lib;
let
  cfg = config.olduser101.print;
in
{
  options.olduser101.print = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable printing configuration";
    };
  };

  config = mkIf cfg.enable {
    services.printing = {
      enable = true;
      drivers = with pkgs; [
        cnijfilter2
      ];
    };

    services.avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };
  };
}
