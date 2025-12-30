{ pkgs, config, lib, hostMeta, ... }:

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

  home.sessionVariables = {
    EDITOR = "kak";
  };

  olduser101 = {
    dunst.enable = true;
    fonts.enable = true;
    htop.enable = true;
    kak.enable = true;
    irssi.enable = true;
    nlock.enable = true;
    oh-my-zsh.enable = true;
    sidetree.enable = true;
    swaylock.enable = true;
    waybar.enable = true;
    wlsunset.enable = true;
    wofi.enable = true;

    packages = {
      enable = true;
      enableGames = (hostMeta.hostname == "natha-nixos0");
    };

    email = {
      enable = true;
      enableZsh = true;
    };

    kitty = {
      enable = true;
      enableRemoteControl = true;
    };

    shells.zsh = {
      enable = true;
      autoSshAdd = true;

      shellAliases = {
        icat = "kitten icat";
        rebuild = "nixos-rebuild switch --flake ${hostMeta.dotfiles}#${hostMeta.hostname}";
      };
    };

    swayidle = {
      enable = true;
      screenLocker = "${pkgs.nlock}/bin/nlock";
    };

    sway = {
      enable = true;
      autoStart = [ "kitty" "waybar" ];
      screenLocker = "${pkgs.nlock}/bin/nlock";
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
