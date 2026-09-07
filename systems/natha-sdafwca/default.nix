{ pkgs, inputs, ... }:

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
    {
      networking.firewall.allowedTCPPorts = [
        22
        80
        443
      ];
      networking.networkmanager.enable = pkgs.lib.mkForce false;

      users.groups.git = {
        name = "git";
        members = [
          "natha"
          "git"
          "cgit"
        ];
        gid = 991;
      };

      services.tailscale = {
        enable = true;
        openFirewall = true;
        useRoutingFeatures = "server";
      };

      services.caddy = {
        enable = true;
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
        };
      };
    }
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
