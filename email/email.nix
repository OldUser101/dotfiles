{ config, pkgs, ... }:

{
  # OldUser101 email configuration

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
      "nathan.j.gill@outlook.com" = {
        primary = true;

        realName = "Nathan Gill";
        address = "nathan.j.gill@outlook.com";
        userName = "nathan.j.gill@outlook.com";

        imap = {
          host = "outlook.office365.com";
          port = 993;
          authentication = "xoauth2";
          tls.enable = true;
        };

        smtp = {
          host = "smtp-mail.outlook.com";
          port = 587;
          authentication = "xoauth2";
          tls.enable = true;
        };

        msmtp = {
          enable = true;
          extraConfig = {
            auth = "xoauth2";
            tls_starttls = "on";
            protocol = "smtp";
            logfile = "${config.home.homeDirectory}/.msmtp.log";
          };
        };

        mbsync = {
          enable = true;
          create = "both";

          extraConfig.account = {
            AuthMechs = "XOAUTH2";
          };
        };

        neomutt = {
          enable = true;
          mailboxName = "Inbox";
          mailboxType = "maildir";
          sendMailCommand = "${pkgs.msmtp}/bin/msmtp";

          extraMailboxes = [
            "Sent"
            "Junk"
            "Deleted"
            "Drafts"
          ];

          extraConfig =
            let
              src = ./.;
            in
              "source ${src}/colorschemes/catppuccin";
        };

        passwordCommand = "${pkgs.python3}/bin/python3 ${pkgs.neomutt}/share/neomutt/oauth2/mutt_oauth2.py ${config.home.homeDirectory}/.config/mutt/outlooktoken --encryption-pipe cat --decryption-pipe cat";
      };
    };
  };

  home.packages = with pkgs; [
    python3
    cyrus-sasl-xoauth2
    
    (pkgs.runCommand "mail-wrapper" { } ''
      mkdir -p $out/bin
      ln -s ${pkgs.neomutt}/bin/neomutt $out/bin/mail
    '')
  ];

  home.sessionVariables = {
    SASL_PATH = "${pkgs.cyrus-sasl-xoauth2}/lib/sasl2";
  };

  systemd.user.services.mbsync.Service.Environment = [
    "SASL_PATH=${pkgs.cyrus-sasl-xoauth2}/lib/sasl2"
    "PATH=/run/current-system/sw/bin"
  ];
}
