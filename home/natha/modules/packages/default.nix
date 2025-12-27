{ pkgs, config, lib, ... }:

with lib;
let
  cfg = config.olduser101.packages;
in {
  options.olduser101.packages = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable optional extra packages";
    };

    extraPackages = mkOption {
      type = types.listOf types.package;
      default = [ ];
      description = "(even more) extra packages to install";
    };
  };

  config = mkIf cfg.enable {
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
    ]
    ++ cfg.extraPackages;
  };
}
