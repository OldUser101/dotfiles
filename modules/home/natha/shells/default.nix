{
  pkgs,
  config,
  lib,
  ...
}:

{
  imports = [
    ./bash
    ./zsh
  ];
}
