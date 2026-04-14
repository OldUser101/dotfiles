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
    ./sddm
    ./security
    ./shells
    ./sway
    ./update
  ];
}
