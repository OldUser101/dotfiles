{ config, pkgs, ... }:

{
  # OldUser101 kakoune configuration

  programs.kakoune = {
    enable = true;
    colorSchemePackage = pkgs.kakounePlugins.kakoune-catppuccin;

    plugins =
      let
        wl-clipboard-kak = pkgs.kakouneUtils.buildKakounePluginFrom2Nix {
          pname = "wl-clipboard-kak";
          version = "2025-12-20";
          src = pkgs.fetchFromGitHub {
            owner = "OldUser101";
            repo = "kak-wl-clipboard";
            rev = "e07b0b58cf9d8548271b5bb52e7e6e40efec2bd9";
            sha256 = "00iqdz71aphm8k0b897mbpxhj84r6fl8j901jklcv7ardznrhb03";
          };
          meta.homepage = "https://github.com/OldUser101/kak-wl-clipboard";
        };
        kak-jj = pkgs.kakouneUtils.buildKakounePluginFrom2Nix {
          pname = "kak-jj";
          version = "2025-12-24";
          src = pkgs.fetchFromGitHub {
            owner = "OldUser101";
            repo = "kak-jj";
            rev = "fb334a0a955be231269ee17d75005104e295ab14";
            sha256 = "0j4wffh5fi4lgcxz69w12bbwjsncb83mfpk788aw024p9709gyf2";
          };
          meta.homepage = "https://github.com/OldUser101/kak-jj";
        };
      in
        with pkgs.kakounePlugins; [
          auto-pairs-kak
          kak-ansi
          kak-jj
          kakoune-lsp
          smarttab-kak
          wl-clipboard-kak
        ];
    
    config = {
      colorScheme = "catppuccin_mocha";
      indentWidth = 4;
      tabStop = 4;

      numberLines = {
        enable = true;
        highlightCursor = true;
      };

      ui = {
        assistant = "none";
        enableMouse = true;
        setTitle = true;
      };

      hooks = [
        {
          name = "ClientCreate";
          once = true;
          option = ".*";
          commands = "
          evaluate-commands %sh{ kak-lsp }
          evaluate-commands %sh{ kcr init kakoune }
          enable-auto-pairs
          expandtab
          set global softtabstop 4
          ";
        }
        {
          name = "BufCreate";
          option = "/.*";
          commands = "
          expandtab
          hook buffer NormalIdle .* %{
            try %{
              eval %sh{ [ \"$kak_modified\" = false ] && printf 'fail' }
              write
            }
          }
          ";
        }
        {
          name = "WinSetOption";
          option = "filetype=(nix|css)";
          commands = "
          expandtab
          set buffer indentwidth 2
          set buffer tabstop 2
          set buffer softtabstop 2
          ";
        }
        {
          name = "WinSetOption";
          option = "filetype=(rust|python|c|cpp|javascript|typescript|zig)";
          commands = "lsp-enable-window";
        }
        {
          name = "RegisterModified";
          option = "'\"'";
          commands = "wl-clipboard-copy";
        }
      ];

      keyMappings = [
        {
          mode = "user";
          key = "l";
          docstring = "LSP mode";
          effect = ":enter-user-mode lsp<ret>";
        }
        {
          mode = "normal";
          key = "<c-b>";
          docstring = "Delete buffer";
          effect = ":db<ret>";
        }
        {
          mode = "normal";
          key = "p";
          effect = ":wl-clipboard-paste<ret>p";
        }
        {
          mode = "normal";
          key = "P";
          effect = ":wl-clipboard-paste<ret>P";
        }
        {
          mode = "normal";
          key = "<c-e>";
          docstring = "Open sidetree";
          effect = ":connect kitty-terminal-window sh -c sidetree<ret>";
        }
      ];
    };
  };

  home.packages = with pkgs; [
    kakoune-cr
    wl-clipboard
  ];
}
