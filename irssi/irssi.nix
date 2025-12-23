{ config, pkgs, ... }:

{
  programs.irssi = {
    enable = true;

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
            certificateFile = "${config.home.homeDirectory}/.irssi/certs/libera.pem";
          };
        };
      };
    };

    extraConfig =
      let
        src = ./.;
      in
      ''
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
      '';
  };

  home.file.".irssi/catppuccin.theme".source = ./themes/catppuccin.theme;
  home.file.".irssi/scripts/autorun/winnum.pl".source = ./scripts/winnum.pl;
}
