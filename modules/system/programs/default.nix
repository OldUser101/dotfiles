{
  pkgs,
  config,
  lib,
  ...
}:

with lib;
let
  cfg = config.olduser101.programs;
in
{
  options.olduser101.programs = {
    steam = mkOption {
      type = types.bool;
      default = false;
      description = "Enable Steam";
    };
  };

  config = {
    programs.steam = mkIf cfg.steam {
      enable = true;
      extraPackages = with pkgs; [
        mangohud
      ];
      extraCompatPackages = with pkgs; [
        proton-ge-bin
        dwproton-bin
      ];
    };
  };
}
