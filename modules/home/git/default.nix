{ hostName, stateVersion }:
{
  pkgs,
  config,
  ...
}:
{
  home = {
    inherit stateVersion;
    username = "git";
    homeDirectory = "/home/git";
  };

  programs.vim = {
    enable = true;
    defaultEditor = true;
  };

  home.sessionVariables = {
    # be certain of it
    EDITOR = pkgs.lib.mkForce "${pkgs.vim}";
    VISUAL = pkgs.lib.mkForce "${pkgs.vim}";
  };

  programs.git = {
    enable = true;
    settings = {
      core.hooksPath = "/data/git/hooks";
      user = {
        email = "git@ngill.net";
        name = "ngill.net git server";
      };
    };
  };

  home.file."git-shell-commands/help" = {
    executable = true;
    text = ''
      #!/bin/sh
      echo "Welcome to git.ngill.net! :D"
      echo "..but there's not really anything you can do in this shell."
    '';
  };
}
