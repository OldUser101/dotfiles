{
  pkgs,
  inputs,
  system,
  ...
}:

let
  dotfiles-update =
    config:
    pkgs.writeShellScriptBin "dotfiles-update" ''
      set -euo pipefail

      BARE_REPO="/data/git/dotfiles.git"
      BRANCH="master"

      WORKTREE=$(${pkgs.mktemp}/bin/mktemp -d /tmp/gitworktree.XXXXXXX)

      cleanup() {
      	rc=$?

      	${pkgs.git}/bin/git --git-dir="$BARE_REPO" worktree remove -f "$WORKTREE" || true
      	rm -rf "$WORKTREE" || true

      	exit "$rc"
      }

      ${pkgs.git}/bin/git --git-dir="$BARE_REPO" worktree add "$WORKTREE" "$BRANCH"

      trap cleanup EXIT SIGTERM SIGINT

      pushd "$WORKTREE" >/dev/null

      GH_TOKEN=$(cat ${config.age.secrets.gh-access-token.path})

      ${inputs.tack.packages.${system}.default}/bin/tack init --resolver
      RES=$(GH_TOKEN=$GH_TOKEN ${inputs.tack.packages.${system}.default}/bin/tack update)

      if ! ${pkgs.git}/bin/git diff --quiet --exit-code; then
        ${pkgs.git}/bin/git add .
        ${pkgs.git}/bin/git commit -F - <<EOF
      tack: update inputs

      $RES
      EOF
      fi

      popd >/dev/null
    '';

  guestbook = inputs.ngill_net.packages.${system}.guestbook;

  caddy = pkgs.caddy.withPlugins {
    plugins = [ "github.com/WeidiDeng/caddy-cloudflare-ip@v0.0.0-20231130002422-f53b62aa13cb" ];
    hash = "sha256-PgFPKCdJOylY4S51JcJAetrEr9EbypKHM67kgwW0lws=";
  };
in
{
  kernelPackage = pkgs.linuxPackages_latest;
  initrdMods = [
    "ahci"
    "xhci_pci"
    "virtio_pci"
    "virtio_scsi"
    "sd_mod"
    "sr_mod"
    "ext4"
    "virtio_net"
    "virtio_mmio"
    "virtio_blk"
    "9p"
    "9pnet_virtio"
    "virtiofs"
    "virtio_balloon"
    "virtio_console"
    "virtio_rng"
    "virtio_gpu"
  ];
  kernelMods = [ ];
  kernelParams = [ ];
  systemConfig = {
    boot = {
      type = "bios";
      device = "/dev/sda";
    };
    core = {
      enable = true;
      timeZone = "UTC";
      tailscale = true;
    };
    fs = {
      type = "bios-sdafwca";
      dataType = "xfs";
      swap = {
        enable = true;
        type = "partition";
      };
    };
    sshd = {
      enable = true;
      users = [
        "natha"
        "git"
      ];
    };
  };
  users = [
    {
      name = "natha";
      groups = [
        "wheel"
        "git"
      ];
      uid = 1000;
      shell = pkgs.bash;
      sshKeys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICeXZ8vRxqvcxCaOehuxN50MoTp5b7UNRIsn9FvW327x n@ngill.net"
      ];
    }
    {
      name = "git";
      groups = [
        "git"
      ];
      uid = 1001;
      shell = "${pkgs.git}/bin/git-shell";
      sshKeys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICeXZ8vRxqvcxCaOehuxN50MoTp5b7UNRIsn9FvW327x n@ngill.net"
      ];
    }
  ];
  cpuCores = 4;
  extraNixosModules = [
    inputs.lanzaboote.nixosModules.lanzaboote
    inputs.agenix.nixosModules.default
    {
      age.secrets.gh-access-token = {
        file = ../../secrets/system/gh-access-token.age;
        mode = "0640";
        owner = "root";
        group = "git";
      };

      networking.firewall.allowedTCPPorts = [
        22
        80
        443
      ];
      networking.networkmanager.enable = pkgs.lib.mkForce false;

      users.groups.git = {
        name = "git";
        members = [
          "root"
          "natha"
          "git"
          "cgit"
        ];
        gid = 991;
      };

      users.users.guestbook = {
        name = "guestbook";
        createHome = false;
        isNormalUser = false;
        isSystemUser = true;
        group = "guestbook";
        uid = 1002;
      };

      users.groups.guestbook = {
        name = "guestbook";
        members = [
          "guestbook"
        ];
        gid = 992;
      };

      services.tailscale = {
        enable = true;
        openFirewall = true;
        useRoutingFeatures = "server";
      };

      services.phpfpm.pools.guestbook = {
        user = "guestbook";
        group = "guestbook";

        phpPackage = pkgs.php;

        settings = {
          "listen" = "/run/phpfpm/guestbook.sock";
          "listen.owner" = "caddy";
          "listen.group" = "caddy";
          "listen.mode" = "0660";

          "pm" = "ondemand";
          "pm.max_children" = 4;
          "pm.process_idle_timeout" = "10s";
          "pm.max_requests" = 500;
        };
      };

      services.caddy = {
        enable = true;
        package = caddy;
        globalConfig = ''
          servers {
            trusted_proxies cloudflare {
              interval 1h
            }
            client_ip_headers CF-Connecting-IP
          }
        '';
        virtualHosts = {
          "obj.ngill.net".extraConfig = ''
            root * /data/obj

            @files {
              path *.*
            }

            header @files {
              Cache-Control "public, max-age=31536000, immutable"
            }

            file_server browse
          '';
          "multi-scrobbler.ngill.net".extraConfig = ''
            bind 100.107.35.98
            reverse_proxy 127.0.0.1:9078
          '';
          "http://natha-sdafwca.tail48a497.ts.net".extraConfig = ''
            bind 100.107.35.98
            reverse_proxy 127.0.0.1:9078
          '';
          "guestbook.ngill.net".extraConfig = ''
            root * ${guestbook}

            @messages path /
            rewrite @messages /guestbook.php

            php_fastcgi unix//run/phpfpm/guestbook.sock
          '';
        };
      };

      virtualisation.docker.enable = true;
      environment.systemPackages = [
        pkgs.docker-compose
      ];

      systemd.services."multi-scrobbler" = {
        enable = true;
        after = [ "docker.service" ];
        requires = [ "docker.service" ];
        path = with pkgs; [
          docker
          docker-compose
        ];
        serviceConfig = {
          WorkingDirectory = "/data/multi-scrobbler";
          ExecStart = "${pkgs.docker}/bin/docker compose up";
          ExecStop = "${pkgs.docker}/bin/docker compose down";
          Restart = "always";
          RemainAfterExit = true;
        };
        wantedBy = [ "multi-user.target" ];
      };
    }
    ({ config, ... }: {
      environment.systemPackages = [
        (dotfiles-update config)
      ];

      systemd.timers."dotfiles-update" = {
        enable = true;
        wantedBy = [ "timers.target" ];
        timerConfig = {
          OnCalendar = "*-*-* 05:42:00 UTC";
          Persistent = true;
          Unit = "dotfiles-update.service";
        };
      };

      systemd.services."dotfiles-update" = {
        path = with pkgs; [
          git
          openssh
          inputs.tack.packages.${system}.default
        ];
        serviceConfig = {
          Type = "oneshot";
          User = "git";
          Group = "git";
          ExecStart = "${dotfiles-update config}/bin/dotfiles-update";
          RemainAfterExit = false;
        };
      };
    })
    (import ./cgit.nix { inherit pkgs; })
  ];
  extraHomeManagerModules = [
    inputs.nlock.homeManagerModules.default
    inputs.way-edges.homeManagerModules.default
    inputs.agenix.homeManagerModules.default
    inputs.wl-overlay.homeManagerModules.wl-overlay
    inputs.mango.hmModules.mango
  ];
}
