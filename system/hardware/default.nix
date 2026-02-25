{ pkgs, config, lib, ... }:

{
  imports = [
    ./bluetooth
    ./firmware
    ./graphics
  ];
}
