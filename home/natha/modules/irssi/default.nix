{ pkgs, config, lib, ... }:

with lib;
let
  cfg = config.olduser101.irssi;
in {
  options.olduser101.irssi = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable irssi";
    };

    certificateDirectory = mkOption {
      type = types.externalPath;
      default = "${config.home.homeDirectory}/.irssi/certs";
      description = "Directory to source SSL certificates from";
    };

    extraConfig = mkOption {
      type = types.str;
      default = "";
      description = "Extra configuration file lines";
    };
  };

  config = mkIf cfg.enable {
    programs.irssi = {
      networks = {
        liberachat = {
          nick = "olduser101";
          saslExternal = true;

          server = {
            address = "irc.libera.chat";
            port = 6697;
            autoConnect = true;

            ssl = {
              enable = true;
              certificateFile = "${cfg.certificateDirectory}/liberachat.pem";
            };
          };
        };
      };

      extraConfig = ''
        settings = {
          core = {
            real_name = "Nathan Gill";
            user_name = "olduser101";
            nick = "olduser101";
          };
          "fe-common/core" = {
            theme = "catppuccin";
          };
        };
      '' + cfg.extraConfig;
    };
  };
}
