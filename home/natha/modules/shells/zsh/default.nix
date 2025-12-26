{ pkgs, config, lib, ... }:

with lib;
let
  cfg = config.olduser101.shells.zsh;
in {
  options.olduser101.shells.zsh = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable zsh";
    };

    shellAliases = mkOption {
      type = types.attrs;
      default = {};
      description = "extra zsh shell aliases";
    };

    options = mkOption {
      type = types.listOf types.str;
      default = [];
      description = "extra zsh options";
    };

    extraContent = mkOption {
      type = types.str;
      default = "";
      description = "Additional content for zshrc";
    };
  };

  config = mkIf cfg.enable {
    programs.zsh = {
      enable = true;
      enableCompletion = true;
      autocd = true;

      setOptions = [
        "PATH_DIRS"
        "PROMPT_SUBST"
      ] ++ cfg.options;

      shellAliases = {
        c = "clear";
      } // cfg.shellAliases;

      initContent = cfg.extraContent;
    };
  };
}
