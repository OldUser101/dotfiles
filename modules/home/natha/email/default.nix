{
  pkgs,
  config,
  lib,
  ...
}:

with lib;
let
  cfg = config.olduser101.email;
in
{
  options.olduser101.email = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable email configuration";
    };

    extraMailboxes = mkOption {
      type = types.listOf types.str;
      default = [ ];
      description = "Extra mailboxes to configure";
    };
  };

  config = mkIf cfg.enable {
    services.mbsync.enable = true;

    programs = {
      mbsync.enable = true;
      msmtp.enable = true;
      neomutt = {
        enable = true;
        editor = "kak";
        vimKeys = true;
      };
    };

    accounts.email = {
      maildirBasePath = "mail";
      accounts = {
        "n@ngill.net" = {
          primary = true;

          realName = "Nathan Gill";
          address = "n@ngill.net";
          userName = "nathan.j.gill@icloud.com";

          imap = {
            host = "imap.mail.me.com";
            port = 993;
            tls.enable = true;
          };

          smtp = {
            host = "smtp.mail.me.com";
            port = 587;
            tls.enable = true;
          };

          msmtp = {
            enable = true;
            extraConfig = {
              auth = "plain";
              tls_starttls = "on";
              protocol = "smtp";
              logfile = "${config.home.homeDirectory}/.msmtp.log";
            };
          };

          mbsync = {
            enable = true;
            create = "both";
            extraConfig.account = {
              AuthMechs = "PLAIN";
            };
          };

          neomutt = {
            enable = true;
            mailboxName = "Inbox";
            mailboxType = "maildir";
            sendMailCommand = "${pkgs.msmtp}/bin/msmtp";

            extraMailboxes = [
              "Sent Messages"
              "Junk"
              "Deleted Messages"
              "Drafts"
            ]
            ++ cfg.extraMailboxes;

            extraConfig =
              let
                src = ./.;
              in
              ''
                source ${src}/colorschemes/catppuccin
                bind index <return> display-message
              '';
          };

          passwordCommand = "cat ${config.age.secrets.email-password.path}";
        };
      };
    };

    home.packages = with pkgs; [
      python3

      # Add a `mail` symlink
      (pkgs.runCommand "mail-wrapper" { } ''
        mkdir -p $out/bin
        ln -s ${pkgs.neomutt}/bin/neomutt $out/bin/mail
      '')
    ];
  };
}
