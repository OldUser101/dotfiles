{
  pkgs,
  config,
  lib,
  ...
}:

with lib;
let
  cfg = config.olduser101.git;
in
{
  options.olduser101.git = {
    enable = mkOption {
      type = types.bool;
      default = true;
      description = "Enable git configuration";
    };

    email = mkOption {
      type = types.str;
      default = "n@ngill.net";
    };

    sshKey = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = "Path to an SSH key for signing";
    };
  };

  config = mkIf cfg.enable {
    programs.git = {
      enable = true;
      settings = [
        {
          user = {
            name = "Nathan Gill";
            email = cfg.email;
          };
          core.pager = "${pkgs.less}/bin/less -FR --mouse";
        }

        (optionalAttrs (cfg.sshKey != null) {
          user.signingkey = cfg.sshKey or "";
          gpg.format = "ssh";
          commit.gpgsign = true;
          tag.gpgsign = true;
        })
      ];
    };
  };
}
