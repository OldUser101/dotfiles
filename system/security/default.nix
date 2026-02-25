{ pkgs, config, lib, ... }:

{
  imports = [
    ./pam
    ./sudo
  ];
}
