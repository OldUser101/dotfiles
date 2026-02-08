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
          boot.loader = {
            systemd-boot.enable = true;
            efi.canTouchEfiVariables = true;
            timeout = 0;
          };
        })
      ];
    in
    bootConfig;
}
