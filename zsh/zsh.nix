{ config, pkgs, ... }:

{
  # OldUser101 zsh configuration

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autocd = true;
  };
}
