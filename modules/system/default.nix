{
  pkgs,
  config,
  lib,
  ...
}:

{
  imports = [
    ./audio
    ./boot
    ./core
    ./fs
    ./hardware
    ./mango
    ./power
    ./print
    ./programs
    ./sddm
    ./security
    ./shells
    ./sway
    ./update
  ];
}
