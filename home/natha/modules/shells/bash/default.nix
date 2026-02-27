{
  pkgs,
  config,
  lib,
  ...
}:

with lib;
let
  cfg = config.olduser101.shells.bash;
in
{
  options.olduser101.shells.bash = {
    enable = mkOption {
      type = types.bool;
      default = true;
      description = "Enable bash configuration";
    };

    shellAliases = mkOption {
      type = types.attrs;
      default = { };
      description = "Extra bash shell aliases";
    };
  };

  config = mkIf cfg.enable {
    programs.bash = {
      enable = true;
      enableCompletion = true;

      shellOptions = [
        "autocd"
      ];

      shellAliases = {
        c = "clear";
        "_" = "sudo ";
      }
      // cfg.shellAliases;

      bashrcExtra = ''
        ${pkgs.openssh}/bin/ssh-add > /dev/null 2>&1

        set_prompt() {
          if [[ $? -eq 0 ]]; then
            STATUS="\[\e[32m\]→"
          else
            STATUS="\[\e[31m\]✕"
          fi
          PS1="\[\e[1m\]''${STATUS} \[\e[36m\]\W\[\e[0m\] "
        }

        PROMPT_COMMAND=set_prompt
      '';
    };
  };
}
