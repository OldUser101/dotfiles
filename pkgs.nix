{ config, pkgs, ... }:

{
  # OldUser101 extra packages

  home.packages = with pkgs; [
    # C/C++
    cmake
    gcc
    gnumake

    # Misc
    calibre
    delta
    discord
    firefoxpwa
    fnm
    jujutsu

    # Python
    python3
    uv

    # Rust
    cargo
    rust-analyzer
    rustc

    # Util
    brightnessctl
    pavucontrol

  ];
}
