{
  pkgs,
  config,
  lib,
  ...
}:

with lib;
let
  cfg = config.olduser101.sshd;
in
{
  options.olduser101.sshd = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable OpenSSH daemon";
    };

    users = mkOption {
      type = types.listOf types.str;
      default = [ ];
      description = "Allowed SSH users";
    };
  };

  config = mkIf cfg.enable {
    services.openssh = {
      enable = true;
      openFirewall = true;
      settings = {
        PasswordAuthentication = false;
        KbdInteractiveAuthentication = false;
        PermitRootLogin = "no";
        MaxAuthTries = 3;
        AllowUsers = cfg.users;
        PerSourcePenalties = "crash:3600s authfail:3600s max:86400s";
      };
    };
  };
}
