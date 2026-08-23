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
    boot = {
      type = "bios";
      device = "/dev/sda";
    };
    core = {
      enable = true;
      tailscale = true;
    };
    power = {
      enable = true;
      profile = "laptop";
    };
    fs = {
      type = "bios-default";
      swap = {
        enable = true;
        type = "partition";
      };
    };
    hardware.firmware.enable = true;
    hardware.graphics = {
      enable = true;
      type = "intel";
    };
    security.pam = {
      services = [
        "swaylock"
        "nlock"
      ];
      keyring = true;
    };
    sddm.enable = true;
    sway.enable = true;
    update.enable = true;
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
