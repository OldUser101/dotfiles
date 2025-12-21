{ config, pkgs, ... }:

{
  # OldUser101 extra packages

  home.packages = with pkgs; [
    # C/C++
    cmake
    gcc
    gnumake

    # Misc
    discord
    firefoxpwa

    # Python
    python3

    # Rust
    cargo
    rust-analyzer
    rustc

    # Util
    brightnessctl
    pavucontrol

    # VCS
    jujutsu
  ];
}
