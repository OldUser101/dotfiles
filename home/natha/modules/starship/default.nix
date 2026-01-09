{
  pkgs,
  config,
  lib,
  ...
}:

with lib;
let
  cfg = config.olduser101.starship;
in
{
  options.olduser101.starship = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable starship";
    };

    enableZsh = mkOption {
      type = types.bool;
      default = true;
      description = "Enable starship zsh integration";
    };

    mailBox = mkOption {
      type = types.str;
      default = "";
      description = "Path to mailbox";
    };
  };

  config = mkIf cfg.enable {
    programs.starship = {
      enable = true;
      enableZshIntegration = cfg.enableZsh;

      settings = {
        character = {
          success_symbol = "[→](bold green)";
          error_symbol = "[✕](bold red)";
        };

        direnv = {
          disabled = false;
        };

        format = concatStrings [
          "$username"
          "$hostname"
          "$directory"
          "$git_branch"
          "$git_commit"
          "$git_state"
          "$git_metrics"
          "$git_status"
          "\${custom.jj_change}"
          "\${custom.jj_desc}"
          "$package"
          "$c"
          "$cmake"
          "$nodejs"
          "$python"
          "$ocaml"
          "$rust"
          "$zig"
          "$nix_shell"
          "$direnv"
          "$line_break"
          "$time"
          "$status"
          "$character"
        ];

        custom = {
          # https://github.com/starship/starship/discussions/1252#discussioncomment-13570845
          jj_change = {
            description = "The working copy of the repo in your current directory: workspaces (if relevant), change ID, bookmarks";
            command = ''
              jj log --no-graph -r=@ -T='separate(" ", working_copies, change_id.shortest(), bookmarks,)'
            '';
            when = ''
              test -d "./.jj" && test -n "$(jj status)" || exit 1
            '';
            format = "on [$symbol ($output)]($style) ";
            symbol = "🐦";
            style = "bold purple";
            ignore_timeout = true;
          };

          # https://github.com/starship/starship/discussions/1252#discussioncomment-13570845
          jj_desc = {
            description = "The description of your working copy, if set";
            command = ''
              jj log --no-graph -r=@ -T="description.first_line()" | awk '{if(length($0) > 25) {s = substr($0, 1, 25); sub(/[ \t\r\n]+$/, "", s); print s "…"} else {print $0}}'
            '';
            when = ''
              test -d "./.jj" && test -n "$(jj status)" -a -n "$(jj log --no-graph -r=@ -T='description')" || exit 1
            '';
            format = "$symbol [($output)]($style) ";
            symbol = "|";
            ignore_timeout = true;
          };
        };
      };
    };
  };
}
