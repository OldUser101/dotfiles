{ pkgs, config, lib, ... }:

{
  imports = [
    ./core
    #./email
    #./irssi
    #./kak
    #./nlock
    #./oh-my-zsh
    ./packages
  ];
}
