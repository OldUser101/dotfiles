{ pkgs, config, lib, ... }:

with lib;
let
  cfg = config.olduser101.core;
in {
  options.olduser101.core = {
    enable = mkOption {
      type = types.bool;
      default = true;
      description = "Enable core options";
    };

    timeZone = mkOption {
      type = types.str;
      default = "Europe/London";
      description = "Time zone";
    };
  };

  config = mkIf cfg.enable {
    i18n.defaultLocale = "en_GB.UTF-8";
    console.useXkbConfig = true;
    services.xserver.xkb.layout = "gb";
   
    time.timeZone = cfg.timeZone;

    nix.settings.experimental-features = [
      "nix-command"
      "flakes"
    ];

    environment.systemPackages = with pkgs; [
      curl
      git
      parted
      wget
      vim
    ];
    
    programs.nix-ld.enable = true;
    programs.ssh.startAgent = true;
  };
}
