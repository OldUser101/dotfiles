{ pkgs, config, lib, ... }:

with lib;
let
  cfg = config.olduser101.kak;
in {
  options.olduser101.kak = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable kakoune";
    };

    extraPlugins = mkOption {
      type = types.listOf types.package;
      default = [ ];
      description = "Extra kakoune plugins to install";
    };

    extraHooks = mkOption {
      type = types.listOf types.attrs;
      default = [ ];
      description = "Extra kakoune hooks to install";
    };

    extraKeyMappings = mkOption {
      type = types.listOf types.attrs;
      default = [ ];
      description = "Extra kakoune key mappings to install";
    };

    extraConfig = mkOption {
      type = types.str;
      default = "";
      description = "Extra configuration file lines";
    };

    extraPackages = mkOption {
      type = types.listOf types.package;
      default = [ ];
      description = "Extra packages to install";
    };
  };

  config = mkIf cfg.enable {
    programs.kakoune = {
      enable = true;
      colorSchemePackage = pkgs.kakounePlugins.kakoune-catppuccin;

      plugins = with pkgs.kakounePlugins; [
        auto-pairs-kak
        kak-ansi
        kak-jj
        kakoune-lsp
        smarttab-kak
        wl-clipboard-kak
      ] ++ cfg.extraPlugins;

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
        ] ++ cfg.extraHooks;

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
            effect = ":connect kitty-terminal-window sh -c '${pkgs.sidetree}/bin/sidetree'<ret>";
          }
        ] ++ cfg.extraKeyMappings;
      };

      extraConfig = cfg.extraConfig;
    };

    home.packages = with pkgs; [
      kakoune-cr
      sidetree
    ] ++ cfg.extraPackages;
  };
}
