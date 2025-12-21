{ config, pkgs, ... }:

{
  # OldUser101 zsh configuration

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autocd = true;

    setOptions = [
      "PATH_DIRS"
      "PROMPT_SUBST"
    ];

    shellAliases = {
      c = "clear";
      rebuild = "home-manager build switch";
    };

    initContent = "
maildir_count() {
    local maildir=\"$HOME/mail/nathan.j.gill@outlook.com/Inbox/new\"
    if [[ -d \"$maildir\" ]]; then
        local count=$(find \"$maildir\" -type f | wc -l)
        (( count > 0 )) && echo \"%B%F{yellow}[$count]%f%b  \"
    fi
}

PROMPT='$(maildir_count)'\"$PROMPT\"
";
  };
}
