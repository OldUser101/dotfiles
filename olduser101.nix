{ config, pkgs, ... }:

{
  # OldUser101 configuration root, just imports application specific configs

  imports = [
    ./oh-my-zsh/oh-my-zsh.nix
    ./zsh/zsh.nix
  ];
}
