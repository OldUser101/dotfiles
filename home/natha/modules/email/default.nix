{ pkgs, config, lib, ... }:

with lib;
let
  cfg = config.olduser101.email;
in {
  options.olduser101.email = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable email configuration";
    };

    enableZsh = mkOption {
      type = types.bool;
      default = true;
      description = "Enable email-related zsh modifications";
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
            ] ++ cfg.extraMailboxes;

            extraConfig =
              let
                src = ./.;
              in
                "source ${src}/colorschemes/catppuccin";
          };

          passwordCommand = ''
            ${pkgs.python3}/bin/python3 \
            ${pkgs.neomutt}/share/neomutt/oauth2/mutt_oauth2.py \
            ${config.home.homeDirectory}/.config/mutt/outlooktoken \
            --encryption-pipe cat --decryption-pipe cat
          '';
        };
      };
    };

    home.packages = with pkgs; [
      python3
      cyrus-sasl-xoauth2

      # Add a `mail` symlink
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

    programs.zsh.initContent = mkIf cfg.enableZsh ''
      maildir_count() {
        local maildir="$HOME/mail/nathan.j.gill@outlook.com/Inbox/new"
        if [[ -d "$maildir" ]]; then
          local count=$(find "$maildir" -type f | wc -l)
          (( count > 0 )) && echo "%B%F{yellow}[$count]%f%b  "
        fi
      }

      PROMPT='$(maildir_count)'"$PROMPT"
    '';
  };
}
