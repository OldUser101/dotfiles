{ pkgs, config, lib, ... }:

with lib;
let
  cfg = config.olduser101.natha.core;
in {
  options.olduser101.natha.core = {
    enable = mkOption {
      type = types.bool;
      default = true;
      description = "Enable core configuration";
    };
  };

  config = mkIf cfg.enable {
    programs.firefox.enable = true;
    services.gnome-keyring.enable = true;
  };
}
