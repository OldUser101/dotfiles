{ hostName, stateVersion }:
{
  pkgs,
  config,
  lib,
  hostMeta,
  ...
}:
let
  assets = ../../../assets;

  hosts = {
    "natha-e2hyref" = {
      programs.firefox.configPath = "${config.xdg.configHome}/mozilla/firefox";

      olduser101 = {
        agenix = {
          enable = true;
          identityPaths = [
            "${config.home.homeDirectory}/.ssh/id_ed25519"
          ];
        };

        git.sshKey = "${config.home.homeDirectory}/.ssh/id_ed25519.pub";
        htop.showBattery = true;
        way-edges.battery = true;

        packages.type = "full";

        sway.outputs =
          let
            bg = "${assets}/wallpapers/bars.jpg";
          in
          {
            eDP-1 = {
              position = "0 0";
              bg = "${bg} fill";
            };
          };
      };
    };

    "natha-76k4epg" = {
      programs.firefox.configPath = "${config.xdg.configHome}/mozilla/firefox";

      olduser101 = {
        agenix = {
          enable = true;
          identityPaths = [
            "${config.home.homeDirectory}/.ssh/id_ed25519"
          ];
        };

        packages.enableGames = true;
        email.enable = true;
        irssi.enable = true;
        git.sshKey = "${config.home.homeDirectory}/.ssh/id_ed25519.pub";
        htop.showGPU = true;

        packages.type = "full";

        sway.outputs =
          let
            bg = "${assets}/wallpapers/bars.jpg";
          in
          {
            "*" = {
              bg = "${bg} fill";
            };
          };
      };
    };

    "natha-vrdhq85".olduser101 = {
      nlock.enable = false;
      swaylock.enable = true;
      waybar.enable = true;
      way-edges.enable = false;
      swayidle.screenLocker = "${pkgs.swaylock}/bin/swaylock";
      sway.screenLocker = "${pkgs.swaylock}/bin/swaylock";
    };

    "natha-5334qwx" = {
      home.packages = with pkgs; [
        sonobus
      ];

      olduser101 = {
        nlock.enable = true;
        htop.showBattery = true;

        sway.outputs =
          let
            bg = "${assets}/wallpapers/bars.jpg";
          in
          {
            LVDS-1 = {
              position = "0 0";
              bg = "${bg} fill";
            };
          };
      };
    };
  };
in
lib.attrsets.recursiveUpdate {
  imports = [ ./modules.nix ];

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

  olduser101 = {
    direnv.enable = true;
    dunst.enable = true;
    fonts.enable = true;
    htop.enable = true;
    kak.enable = true;
    nlock.enable = true;
    qt.enable = true;
    gtk.enable = true;
    way-edges.enable = true;
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
  };
} (hosts.${hostName} or { })
