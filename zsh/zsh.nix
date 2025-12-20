{ config, pkgs, ... }:

{
  # OldUser101 zsh configuration

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autocd = true;

    setOptions = [
      "PATH_DIRS"
    ];

    shellAliases = {
      c = "clear";
      rebuild = "home-manager build switch";
    };
  };
}
