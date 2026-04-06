{ hostName, stateVersion }:
{
  pkgs,
  config,
  lib,
  hostMeta,
  ...
}:
let
  hosts = {
    "natha-nixos0" = {
      packages.enableGames = true;
      email.enable = true;
      irssi.enable = true;

      packages.type = "full";

      sway.outputs =
        let
          bg = "${config.home.homeDirectory}/pictures/wallpapers/default.png";
        in
        {
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

    "natha-vrdhq85" = {
      nlock.enable = false;
      swaylock.enable = true;
      swayidle.screenLocker = "${pkgs.swaylock}/bin/swaylock";
      sway.screenLocker = "${pkgs.swaylock}/bin/swaylock";
    };

    "natha-5334qwx" = {
      nlock.enable = true;
    };
  };
in
{
  imports = [ ./modules ];

  home = {
    inherit stateVersion;
    username = "natha";
    homeDirectory = "/home/natha";
  };

  systemd.user.startServices = true;

  programs.firefox = {
    enable = true;
    nativeMessagingHosts = [ pkgs.firefoxpwa ];
  };

  services.gnome-keyring.enable = true;
  home.packages = [ pkgs.gcr ];

  olduser101 = lib.attrsets.recursiveUpdate {
    direnv.enable = true;
    dunst.enable = true;
    fonts.enable = true;
    htop.enable = true;
    kak.enable = true;
    nlock.enable = true;
    waybar.enable = true;
    wlsunset.enable = true;
    wofi.enable = true;
    zellij.enable = true;

    packages.type = "minimal";

    shells.bash = {
      enable = true;

      shellAliases = {
        update = "systemctl restart pull-updates.service";
        rebuild = "systemctl restart rebuild.service";
        localRebuild = "nixos-rebuild switch --flake ${hostMeta.localDotfiles}#${hostMeta.hostname}";
      };
    };

    swayidle = {
      enable = true;
      screenLocker = "${pkgs.nlock}/bin/nlock";
    };

    sway.screenLocker = "${pkgs.nlock}/bin/nlock";
  } (hosts.${hostName} or { });
}
