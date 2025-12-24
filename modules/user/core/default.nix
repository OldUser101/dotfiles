{ pkgs, config, lib, ... }:

{
  imports = [
    ./dunst
    ./fonts
    ./htop
    #./kitty
    #./sway
    ./swaylock
    #./waybar
    ./wlsunset
    #./wofi
    #./zsh
  ];
}
