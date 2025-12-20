{ config, pkgs, ... }:

{
  # OldUser101 configuration root, just imports application specific configs

  imports = [
    ./dunst/dunst.nix
    ./kitty/kitty.nix
    ./sway/sway.nix
    ./oh-my-zsh/oh-my-zsh.nix
    ./wlsunset/wlsunset.nix
    ./zsh/zsh.nix
  ];
}
