{ config, pkgs, ... }:

{
  # OldUser101 configuration root, just imports application specific configs

  imports = [
    ./dunst/dunst.nix
    ./htop/htop.nix
    ./kak/kak.nix
    ./kitty/kitty.nix
    ./sway/sway.nix
    ./swaylock/swaylock.nix
    ./oh-my-zsh/oh-my-zsh.nix
    ./waybar/waybar.nix
    ./wlsunset/wlsunset.nix
    ./zsh/zsh.nix
  ];
}
