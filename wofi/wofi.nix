{ config, pkgs, ... }:

{
  # OldUser101 wofi configuration

  programs.wofi = {
    enable = true;
    style = ./style.css;
  };
}
