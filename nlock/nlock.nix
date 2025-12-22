{ config, pkgs, ... }:

let
  nlockFlake = builtins.getFlake "github:OldUser101/nlock";
in
{
  home.packages = with pkgs; [
    nlockFlake.defaultPackage.${stdenv.hostPlatform.system}
  ];

  home.file.".config/nlock/nlock.toml".source = ./nlock.toml;
}
