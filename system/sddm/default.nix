{ pkgs, config, lib, ... }:

with lib;
let
  cfg = config.olduser101.sddm;

  where-is-my-sddm-theme-classic-nocursor = pkgs.where-is-my-sddm-theme.override {
    themeConfig.General.hideCursor = true;
    themeConfig.General.passwordInputCursorVisible = false;
  };
in {
  options.olduser101.sddm = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable the SDDM display manager";
    };

    wayland = mkOption {
      type = types.bool;
      default = true;
      description = "Enable SDDM Wayland support";
    };

    theme = mkOption {
      type = types.str;
      default = "where_is_my_sddm_theme";
      description = "SDDM theme";
    };

    extraPackages = mkOption {
      type = types.listOf types.package;
      default = [ ];
      description = "Extra packages for SDDM";
    };
    
    extraSystemPackages = mkOption {
      type = types.listOf types.package;
      default = [ ];
      description = "Extra system packages for SDDM";
    };
  };

  config = mkIf cfg.enable {
    services.displayManager.sddm = {
      enable = true;
      wayland.enable = cfg.wayland;

      theme = cfg.theme;

      extraPackages =
        optionals (cfg.theme == "where_is_my_sddm_theme") (with pkgs; [
          where-is-my-sddm-theme-classic-nocursor
          qt6.qt5compat
        ])
        ++ cfg.extraPackages;
    };

    environment.systemPackages =
      optionals (cfg.theme == "where_is_my_sddm_theme") (with pkgs; [
        where-is-my-sddm-theme-classic-nocursor
      ])
      ++ cfg.extraSystemPackages;
  };
}
