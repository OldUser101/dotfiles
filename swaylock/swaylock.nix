{ config, pkgs, ... }:

{
  # OldUser101 swaylock configuration

  programs.swaylock = {
    enable = true;
    settings = {
      color = "1e1e2e";
      show-failed-attempts = true;
    };
  };
}
