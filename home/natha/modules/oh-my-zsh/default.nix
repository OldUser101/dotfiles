{ pkgs, config, lib, ... }:

with lib;
let
  cfg = config.olduser101.oh-my-zsh;
in {
  options.olduser101.oh-my-zsh = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable oh-my-zsh";
    };

    theme = mkOption {
      type = types.str;
      default = "robbyrussell";
      description = "oh-my-zsh theme to load";
    };

    extraPlugins = mkOption {
      type = types.listOf types.str;
      default = [ ];
      description = "Extra plugins to load";
    };
  };

  config = {
    programs.zsh.oh-my-zsh = {
      enable = true;
      plugins = [ "git" ] ++ cfg.extraPlugins;
      theme = cfg.theme;
    };
  };
}
