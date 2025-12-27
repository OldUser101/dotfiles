{ pkgs, config, lib, ... }:

with lib;
let
  cfg = config.olduser101.fonts;
in {
  options.olduser101.fonts = {
    enable = mkOption {
      type = types.bool;
      default = true;
      description = "Enable fonts";
    };

    extraFonts = mkOption {
      type = types.listOf types.package;
      default = [ ];
      description = "Extra font packages";
    };
  };

  config = mkIf cfg.enable {
    fonts.fontconfig.enable = true;
    
    home.packages = with pkgs; [
      noto-fonts
      nerd-fonts.fira-code
      fira-code
      fira-code-symbols
    ] ++ cfg.extraFonts;
  };
}
