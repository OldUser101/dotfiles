{
  pkgs,
  config,
  lib,
  ...
}:

with lib;
let
  cfg = config.olduser101.starship;
in
{
  options.olduser101.starship = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable starship";
    };

    enableZsh = mkOption {
      type = types.bool;
      default = true;
      description = "Enable starship zsh integration";
    };
  };

  config = mkIf cfg.enable {
    programs.starship = {
      enable = true;
      enableZshIntegration = cfg.enableZsh;

      settings = {
        character = {
          success_symbol = "[→](bold green)";
          error_symbol = "[✕](bold red)";
        };

        direnv = {
          disabled = false;
        };
      };
    };
  };
}
