{ pkgs }:
let
  cgit-exec = pkgs.stdenv.mkDerivation {
    name = "cgit-exec";
    version = "1.0";

    src = ./cgit-exec;

    nativeBuildInputs = with pkgs.python3Packages; [
      python
      wrapPython
    ];

    pythonPath = with pkgs.python3Packages; [
      pygments
      markdown
      catppuccin
    ];

    postPatch = ''
      substituteInPlace html-converters/man2html \
        --replace 'groff' '${pkgs.groff}/bin/groff'

      substituteInPlace html-converters/rst2html \
        --replace 'rst2html.py' '${pkgs.docutils}/bin/rst2html.py'
    '';

    installPhase = ''
      mkdir -p $out
      cp -r ./* $out/

      wrapPythonProgramsIn "$out/" "$out ''${pythonPath[*]}"

      for script in $out/*.sh $out/html-converters/txt2html; do
        wrapProgram $script --prefix PATH : '${
          pkgs.lib.makeBinPath [
            pkgs.coreutils
            pkgs.gnused
          ]
        }'
      done
    '';
  };

  cgit-clear-cache = pkgs.writeShellScriptBin "cgit-clear-cache" ''
    set -e
    mkdir -p /var/cache/cgit
    rm -rf /var/cache/cgit/*
  '';

  git-init-repo = pkgs.writeShellScriptBin "git-init-repo" ''
    set -euo pipefail

    if [ $# -ne 1 ]; then
      echo "usage: $0 <repo-name>"
      exit 1
    fi

    repo="$1"
    repo="''${repo%.git}"

    repo_dir="/data/git/''${repo}.git"
    link_dir="/home/git/''${repo}.git"

    if [ -e "$repo_dir" ]; then
      echo "repository already exists: $repo_dir"
      exit 1
    fi

    ${pkgs.git}/bin/git init --bare "$repo_dir"

    chown -R git:git "$repo_dir"
    chmod -R g+rwX "$repo_dir"

    find "$repo_dir" -type d -exec chmod g+s {} \;

    ln -s "$repo_dir" "$link_dir"

    echo "$repo repository" > "$repo_dir/description"

    if [ -n "''${EDITOR:-}" ]; then
      "$EDITOR" "$repo_dir/description"
    fi

    echo "created repo at $repo_dir"
  '';
in
{
  services.cgit."public" = {
    enable = true;
    nginx = {
      virtualHost = "cgit";
      location = "/";
    };
    settings = {
      cache-size = 1000;
      cache-repo-ttl = 2;
      cache-about-ttl = 2;
      cache-snapshot-ttl = 2;
      cache-scanrc-ttl = 2;

      clone-prefix = "https://git.ngill.net";

      # this is handled by git-http-backend
      enable-http-clone = 0;
      enable-blame = 1;
      enable-commit-graph = 1;
      max-stats = "year";

      root-title = "Git Repositories | Nathan Gill";
      root-desc = "just some \"cool stuff\", probably mirrored elsewhere :D";

      "mimetype.gif" = "image/gif";
      "mimetype.html" = "text/html";
      "mimetype.jpg" = "image/jpeg";
      "mimetype.jpeg" = "image/jpeg";
      "mimetype.pdf" = "application/pdf";
      "mimetype.png" = "image/png";
      "mimetype.svg" = "image/svg+xml";

      readme = [
        ":README.md"
        ":readme.md"
        ":README"
        ":readme"
      ];

      section-from-path = 1;
      virtual-root = "/";

      css = "/cgit-ext/cgit-catppuccin.css";
      favicon = "/cgit-ext/favicon.ico";
      logo = "/cgit-ext/avatar.jpg";

      source-filter = "${cgit-exec}/syntax-highlighting.py";
      about-filter = "${cgit-exec}/about-formatting.sh";
    };
    gitHttpBackend = {
      enable = true;
      checkExportOkFiles = false;
    };
    scanPath = "/data/git";
    user = "cgit";
    group = "git";
  };

  services.nginx = {
    enable = true;
    virtualHosts."cgit" = {
      listen = [
        {
          addr = "127.0.0.1";
          port = 8080;
        }
      ];
      locations = {
        "/cgit-ext".root = ./cgit-data;
      };
    };
  };

  services.anubis.instances."cgit" = {
    enable = true;
    settings = {
      BIND = ":2770";
      BIND_NETWORK = "tcp";
      DIFFICULTY = 5;
      METRICS_BIND = ":9090";
      METRICS_BIND_NETWORK = "tcp";
      SERVE_ROBOTS_TXT = true;
      TARGET = "http://127.0.0.1:8080";
      WEBMASTER_EMAIL = "n@ngill.net";
    };
  };

  services.caddy = {
    enable = true;
    virtualHosts = {
      "git.ngill.net".extraConfig = ''
        reverse_proxy 127.0.0.1:2770 {
          header_up X-Real-Ip {remote_host}
          header_up X-Http-Version {http.request.proto}
        }
      '';
    };
  };

  programs.git = {
    enable = true;
    config = {
      safe.directory = "/data/git/*";
    };
  };

  environment.systemPackages = [
    cgit-clear-cache
    git-init-repo
  ];
}
