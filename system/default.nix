{ pkgs, config, lib, ... }:

{
  imports = [
    ./audio
    ./boot
    ./core
    ./fs
    ./hardware
    ./power
    ./sddm
    ./security
    ./shells
    ./sway
    ./update
  ];
}
