{
  pkgs,
  config,
  lib,
  ...
}:

with lib;
let
  cfg = config.olduser101.nlock;
in
{
  options.olduser101.nlock = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable nlock configuration";
    };
  };

  config = mkIf cfg.enable {
    programs.nlock = {
      enable = true;
      settings = {
        colors = {
          background = "1E1E2E";
          inputBackground = "1E1E2E";
          text = "CDD6F4";
        };

        font = {
          size = 72.0;
          useDpiScaling = true;
          family = "monospace";
          slant = "normal";
          weight = "bold";
        };

        input = {
          maskChar = "*";
        };
      };
    };
  };
}
