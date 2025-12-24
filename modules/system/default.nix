{ pkgs, config, lib, ... }:

{
  imports = [
    ./audio
    ./boot
    ./core
    ./fs
    ./hardware
    ./sddm
    ./security
    ./shells
  ];
}
