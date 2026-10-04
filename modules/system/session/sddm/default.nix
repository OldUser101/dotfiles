{
  pkgs,
  config,
  ...
}:
{ }:
let
  where-is-my-sddm-theme-classic-nocursor = pkgs.where-is-my-sddm-theme.override {
    themeConfig.General.hideCursor = true;
    themeConfig.General.passwordInputCursorVisible = false;
  };
in
{
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;

    theme = "where_is_my_sddm_theme";

    extraPackages = with pkgs; [
      where-is-my-sddm-theme-classic-nocursor
      qt6.qt5compat
    ];
  };

  # sddm gets restarted if it changes in any way, don't let that happen
  system.switch.inhibitors = {
    sddm = ''
      ${config.services.displayManager.sddm.package}
      ${where-is-my-sddm-theme-classic-nocursor}
    '';
  };

  environment.systemPackages = [
    where-is-my-sddm-theme-classic-nocursor
  ];
}
