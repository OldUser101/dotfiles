{ config, lib, ... }:

{
  imports = [ ./modules ];

  home = {
    username = "natha";
    homeDirectory = "/home/natha";
    stateVersion = "25.11";
  };

  systemd.user.startServices = true;

  programs.firefox.enable = true;
  services.gnome-keyring.enable = true;
    
  olduser101 = {
    dunst.enable = true;
    fonts.enable = true;
    htop.enable = true;
    oh-my-zsh.enable = true;
    packages.enable = true;
    waybar.enable = true;
    wlsunset.enable = true;
    wofi.enable = true;

    kitty = {
      enable = true;
      enableRemoteControl = true;
    };

    shells.zsh = {
      enable = true;
      shellAliases.rebuild = "home-manager switch";
    };

    sway = {
      enable = true;
      autoStart = [ "kitty" "waybar" ];
      outputs =
        let
          bg = "${config.home.homeDirectory}/pictures/wallpapers/default.png";
        in {
        eDP-1 = {
          position = "0 0";
          bg = "${bg} fill";
        };
        HDMI-A-1 = {
          position = "1920 0";
          bg = "${bg} fill";
        };
      };
    };
  };
}
