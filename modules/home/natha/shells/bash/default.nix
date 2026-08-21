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

        mkcd() {
          mkdir -p "$1" && cd "$1"
        }

        xcd() {
          local cur=$(realpath .)
          cd "$1"
          shift
          eval "$@"
          cd "$cur"
        }

        usrmnt() {
          sudo mount -o uid=$UID $@
        }

        hr() {
            local line
            printf -v line '%*s' "$(tput cols)" ""
            printf '%s\n' "''${line// /─}"
        }

        set_prompt() {
          local rc=$?

          # don't run first time
          if [[ $set_prompt_once -eq 1 ]]; then
            if [[ $rc -eq 0 ]]; then
              printf "\e[1;32m"
            else
              printf "\e[1;31m"
            fi
            hr
          fi

          set_prompt_once=1

          if [[ $rc -eq 0 ]]; then
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
