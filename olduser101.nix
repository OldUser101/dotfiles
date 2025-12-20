{ config, pkgs, ... }:

{
  # OldUser101 configuration root, just imports application specific configs

  imports = [
    ./kitty/kitty.nix
    ./sway/sway.nix
    ./oh-my-zsh/oh-my-zsh.nix
    ./zsh/zsh.nix
  ];
}
