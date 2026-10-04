{ pkgs, inputs, ... }:

{
  kernelPackage = pkgs.linuxPackages_latest;
  initrdMods = [
    "ehci_pci"
    "ahci"
    "firewire_ohci"
    "xhci_pci"
    "usb_storage"
    "sd_mod"
    "sr_mod"
    "sdhci_pci"
  ];
  kernelMods = [ ];
  kernelParams = [ ];
  systemConfig = {
    audio = { };

    boot = {
      type = "bios";
      device = "/dev/sda";
    };

    fs = {
      type = "bios-default";
      swap.type = "partition";
    };

    hardware = {
      firmware = { };
      graphics.type = "intel";
    };

    i18n = { };
    misc.update = true;
    network.tailscale = true;
    power.profile = "laptop";

    security = {
      pam.services = [
        "swaylock"
        "nlock"
      ];
      sudo = { };
    };

    session.sddm = { };
    wayland.sway = true;
  };
  hostMeta.localDotfiles = "/home/natha/.config/olduser101";
  users = [
    {
      name = "natha";
      groups = [
        "wheel"
        "networkmanager"
      ];
      uid = 1000;
      shell = pkgs.bash;
    }
  ];
  cpuCores = 8;
  extraNixosModules = [
    inputs.nlock.nixosModules.default
    inputs.agenix.nixosModules.default
  ];
  extraHomeManagerModules = [
    inputs.nlock.homeManagerModules.default
    inputs.way-edges.homeManagerModules.default
    inputs.agenix.homeManagerModules.default
    inputs.wl-overlay.homeManagerModules.wl-overlay
  ];
}
