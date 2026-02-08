{
  pkgs,
  config,
  lib,
  ...
}:

with lib;
let
  cfg = config.olduser101.update;
in
{
  options.olduser101.update = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable automatic update";
    };
  };

  config = mkIf cfg.enable {
    systemd.timers.pull-updates = {
      description = "Run pull-updates service";
      wantedBy = [ "timers.target" ];
      timerConfig = {
        OnBootSec = "2m";
        OnUnitActiveSec = "1d";
        Unit = "pull-updates.service";
      };
    };

    systemd.services.pull-updates = {
      description = "Pull NixOS and home-manager configuration";
      restartIfChanged = false;
      onSuccess = [ "rebuild.service" ];
      after = [ "network-online.target" ];
      wants = [ "network-online.target" ];
      path = with pkgs; [
        git
        openssh
      ];
      script = ''
        test "$(git branch --show-current)" = "master"
        git pull --ff-only
      '';
      serviceConfig = {
        WorkingDirectory = "/etc/nixos";
        User = "root";
        Type = "oneshot";
      };
    };

    systemd.services.rebuild = {
      description = "Rebuild NixOS and home-manager configuration";
      restartIfChanged = false;
      path = with pkgs; [
        nixos-rebuild
        systemd
        nix
      ];
      script = ''
        nixos-rebuild switch --flake /etc/nixos#${config.networking.hostName}
        nix-collect-garbage --delete-older-than 30d
      '';
      serviceConfig = {
        WorkingDirectory = "/etc/nixos";
        User = "root";
        Type = "oneshot";
      };
    };
  };
}
