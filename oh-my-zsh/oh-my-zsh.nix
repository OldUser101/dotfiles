{ config, pkgs, ... }:

{
  # OldUser101 oh-my-zsh configuration
  # Naturally, this requires zsh config as well

  programs.zsh = {
    oh-my-zsh = {
      enable = true;
      plugins = [ "git" ];
      theme = "robbyrussell";
    };
  };
}
