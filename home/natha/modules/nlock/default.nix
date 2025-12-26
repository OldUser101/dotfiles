{ pkgs, config, lib, ... }:

with lib;
let
  cfg = config.olduser101.nlock;
in {
  options.olduser101.nlock = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable nlock";
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      nlock
    ];

    home.file.".config/nlock/nlock.toml".text = ''
      [colors]
      background = "#1E1E2E"
      inputBackground = "#1E1E2E"
      text = "#CDD6F4"

      [font]
      size = 72.0
      family = "monospace"
      slant = "normal"
      weight = "bold"

      [input]
      maskChar = "*"
    '';
  };
}
