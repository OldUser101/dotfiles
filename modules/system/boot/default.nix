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
        "efi-secure"
        "bios"
        "baytrail"
      ];
      description = "Bootloader type";
    };

    device = mkOption {
      type = types.str;
      default = "";
      description = "GRUB boot device for BIOS boot type";
    };

    pkiBundle = mkOption {
      type = types.externalPath;
      default = "/var/lib/sbctl";
      description = "Path to secure boot PKI bundle, required for secure EFI boot type";
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

        (mkIf (cfg.type == "efi-secure") {
          environment.systemPackages = with pkgs; [
            sbctl
          ];

          boot.lanzaboote = {
            enable = true;
            pkiBundle = cfg.pkiBundle;
          };

          boot.loader = {
            systemd-boot.enable = mkForce false;
            efi.canTouchEfiVariables = true;
            timeout = 0;
          };
        })

        (mkIf (cfg.type == "bios") {
          boot.loader = {
            timeout = 0;
            grub = {
              enable = true;
              device = cfg.device;
              timeoutStyle = "hidden";
            };
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
