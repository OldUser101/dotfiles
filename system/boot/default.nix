{ pkgs, config, lib, ... }:

with lib;
let
  cfg = config.olduser101.boot;
in {
  options.olduser101.boot = {
    type = mkOption {
      type = types.enum [ "efi" ];
      description = "Bootloader type";
    };
  };

  config =
    let
      bootConfig = mkMerge [
        (mkIf (cfg.type == "efi") {
          boot.loader.systemd-boot.enable = true;
          boot.loader.efi.canTouchEfiVariables = true;
        })
      ];
    in
    bootConfig;
}
