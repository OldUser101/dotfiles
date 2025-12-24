{ pkgs, config, lib, ... }:

{
  imports = [
    ./audio
    ./boot
    ./core
    ./fs
    ./hardware
    ./security
    ./shells
  ];
}
