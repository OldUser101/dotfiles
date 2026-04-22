{
  pkgs,
  config,
  lib,
  ...
}:

with lib;
let
  cfg = config.olduser101.nlock;
  assets = ../../../../assets;
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
        general.backgroundType = "image";
        
        colors = {
          inputBorder = "CBA6F7";
          inputBackground = "1E1E2E";
          text = "CDD6F4";
        };

        font = {
          size = 72.0;
          useDpiScaling = true;
          family = "monospace";
          weight = "bold";
        };

        input = {
          border = 2.0;
          visible = "content";
          fitToContent = true;
        };

        image.path = "${assets}/wallpapers/bars.jpg";
      };
    };
  };
}
