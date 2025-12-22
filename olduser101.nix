{ config, pkgs, ... }:

{
  # OldUser101 configuration root, just imports application specific configs

  imports = [
    ./dunst/dunst.nix
    ./email/email.nix
    ./htop/htop.nix
    ./kak/kak.nix
    ./kitty/kitty.nix
    ./nlock/nlock.nix
    ./sway/sway.nix
    ./swaylock/swaylock.nix
    ./oh-my-zsh/oh-my-zsh.nix
    ./pkgs.nix
    ./waybar/waybar.nix
    ./wlsunset/wlsunset.nix
    ./wofi/wofi.nix
    ./zsh/zsh.nix
  ];
}
