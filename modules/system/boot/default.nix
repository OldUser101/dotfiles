{
  pkgs,
  lib,
  util,
  ...
}:
{
  type,
  device ? "",
  pkiBundle ? "/var/lib/sbctl",
  configLimit ? 3,
}:
let
  type' = util.assertMsg (builtins.elem type [
    "efi"
    "efi-secure"
    "bios"
    "baytrail"
  ]) type "invalid bootloader type";
in
lib.mkMerge [
  (lib.mkIf (type' == "efi") {
    boot.loader = {
      systemd-boot.enable = true;
      systemd-boot.configurationLimit = configLimit;
      efi.canTouchEfiVariables = true;
      timeout = 0;
    };
  })

  (lib.mkIf (type' == "efi-secure") {
    environment.systemPackages = with pkgs; [
      sbctl
    ];

    boot.lanzaboote = {
      inherit pkiBundle;
      enable = true;
    };

    boot.loader = {
      systemd-boot.enable = lib.mkForce false;
      systemd-boot.configurationLimit = configLimit;
      efi.canTouchEfiVariables = true;
      timeout = 0;
    };
  })

  (lib.mkIf (type' == "bios") {
    boot.loader = {
      timeout = 0;
      grub = {
        inherit device;
        enable = true;
        timeoutStyle = "hidden";
        configurationLimit = configLimit;
      };
    };
  })
  (lib.mkIf (type' == "baytrail") {
    boot.loader = {
      efi.canTouchEfiVariables = false;
      grub = {
        enable = true;
        efiSupport = true;
        efiInstallAsRemovable = true;
        device = "nodev";
        forcei686 = true;
        configurationLimit = configLimit;
      };
    };
  })
]
