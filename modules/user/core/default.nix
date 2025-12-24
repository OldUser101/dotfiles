{ pkgs, config, lib, ... }:

{
  imports = [
    ./dunst
    ./fonts
    ./htop
    #./kitty
    ./shells
    #./sway
    ./swaylock
    ./waybar
    ./wlsunset
    ./wofi
  ];
}
