{
  pkgs,
  config,
  lib,
  ...
}:
with lib;
let
  cfg = config.olduser101.display;
in
{
  options.olduser101.display = {
    displaylink = mkOption {
      type = types.bool;
      default = false;
      description = "Enable DisplayLink video drivers";
    };
  };

  config = mkIf cfg.displaylink {
    environment.systemPackages = with pkgs; [
      displaylink
    ];
    services.xserver.videoDrivers = [
      "displaylink"
      "modesetting"
    ];
    boot.extraModulePackages = [ config.boot.kernelPackages.evdi ];
    boot.initrd.kernelModules = [ "evdi" ];
  };
}
