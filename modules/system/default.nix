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
