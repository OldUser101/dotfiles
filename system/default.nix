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
    ./display
    ./fs
    ./hardware
    ./power
    ./print
    ./sddm
    ./security
    ./shells
    ./sway
    ./update
  ];
}
