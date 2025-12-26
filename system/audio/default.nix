{ pkgs, config, lib, ... }:

with lib;
let
  cfg = config.olduser101.audio;
in {
  options.olduser101.audio = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable audio configuration";
    };

    provider = mkOption {
      type = types.enum [ "pipewire" ];
      default = "pipewire";
      description = "Audio provider service";
    };
  };

  config = mkIf cfg.enable (mkMerge [
    (mkIf (cfg.provider == "pipewire") {
      security.rtkit.enable = true;
      services.pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
      };
    })
  ]);
}
