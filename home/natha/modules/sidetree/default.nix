{ pkgs, config, lib, ... }:

with lib;
let
  cfg = config.olduser101.sidetree;
in {
  options.olduser101.sidetree = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable sidetree";
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      kakoune-cr
      sidetree
    ];

    home.file.".config/sidetree/sidetreerc".text = mkForce ''
      set show_hidden true
      set quit_on_open false
      set open_cmd '${pkgs.kakoune-cr}/bin/kcr open "''${sidetree_entry}"'

      set file_icons true
      set icon_style darkgray
      set dir_name_style rgb:a37acc+b
      set file_name_style reset
      set highlight_style +r
      set link_style lightgreen+b

      map <c-c> quit
      map H cd ..
      map L cd
      map o mk
      map c rename
    '';
  };
}
