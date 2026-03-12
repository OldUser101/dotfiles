{
  pkgs,
  config,
  lib,
  ...
}:

with lib;
let
  cfg = config.olduser101.boot;
in
{
  options.olduser101.boot = {
    type = mkOption {
      type = types.enum [
        "efi"
        "baytrail"
      ];
      description = "Bootloader type";
    };
  };

  config =
    let
      bootConfig = mkMerge [
        (mkIf (cfg.type == "efi") {
          boot.loader = {
            systemd-boot.enable = true;
            efi.canTouchEfiVariables = true;
            timeout = 0;
          };
        })

        (mkIf (cfg.type == "baytrail") {
          boot.loader = {
            efi.canTouchEfiVariables = false;
            grub = {
              enable = true;
              efiSupport = true;
              efiInstallAsRemovable = true;
              device = "nodev";
              forcei686 = true;
            };
          };
        })
      ];
    in
    bootConfig;
}
