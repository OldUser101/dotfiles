{ pkgs, config, lib, ... }:

{
  imports = [
    ./boot
    ./core
    ./fs
    ./hardware
    ./security
    ./shells
  ];
}
