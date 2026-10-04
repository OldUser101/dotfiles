{ pkgs, inputs, ... }:

{
  kernelPackage = pkgs.linuxPackages_latest;
  initrdMods = [
    "xhci_pci"
    "ahci"
    "usb_storage"
    "usbhid"
    "sd_mod"
  ];
  kernelMods = [ "kvm-intel" ];
  kernelParams = [ "amdgpu.ppfeaturemask=0xffffffff" ];
  systemConfig = {
    audio = { };

    boot = {
      type = "efi";
      configLimit = 3;
    };

    fs = {
      type = "efi-default";
      swap.type = "partition";
      extraConfig = {
        fileSystems."/data" = {
          device = "/dev/disk/by-label/DATA.EXT";
          fsType = "btrfs";
          options = [
            "compress=zstd:1"
            "noatime"
          ];
        };
      };
    };

    hardware = {
      bluetooth = { };
      firmware = { };
      graphics.type = "amd";
    };

    i18n = { };

    misc = {
      steam = true;
      update = { };
    };

    network.tailscale = true;
    print = { };

    security = {
      sudo = { };
      pam.services = [
        "swaylock"
        "nlock"
      ];
    };

    session.sddm = { };
    wayland.mango = true;
  };
  hostMeta.localDotfiles = "/home/natha/.config/olduser101";
  users = [
    {
      name = "natha";
      groups = [
        "wheel"
        "dialout"
        "networkmanager"
        "input"
      ];
      uid = 1000;
      shell = pkgs.bash;
    }
  ];
  cpuCores = 12;
  extraPackages = [
    inputs.agenix.packages.x86_64-linux.default
  ];
  extraNixosModules = [
    inputs.nlock.nixosModules.default
    inputs.agenix.nixosModules.default
    inputs.lanzaboote.nixosModules.lanzaboote
    inputs.mango.nixosModules.mango
  ];
  extraHomeManagerModules = [
    inputs.nlock.homeManagerModules.default
    inputs.way-edges.homeManagerModules.default
    inputs.agenix.homeManagerModules.default
    inputs.wl-overlay.homeManagerModules.wl-overlay
    inputs.mango.hmModules.mango
  ];
}
