{ pkgs, inputs, ... }:

{
  kernelPackage = pkgs.linuxPackages_latest;
  initrdMods = [
    "xhci_pci"
    "nvme"
    "usbhid"
    "usb_storage"
    "sd_mod"
    "sdhci_pci"
  ];
  kernelMods = [ "kvm-intel" ];
  kernelParams = [ ];
  systemConfig = {
    boot.type = "baytrail";
    core.enable = true;
    power = {
      enable = true;
      profile = "laptop";
    };
    fs = {
      type = "efi-baytrail";
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
      services = [ "swaylock" ];
      keyring = true;
    };
    sway.enable = true;
  };
  hostMeta.localDotfiles = "/home/natha/.config/olduser101";
  users = [
    {
      name = "natha";
      groups = [
        "wheel"
        "dialout"
        "network"
      ];
      uid = 1000;
      shell = pkgs.bash;
    }
  ];
  cpuCores = 4;
  extraNixosModules = [ inputs.nlock.nixosModules.default ];
  extraHomeManagerModules = [
    inputs.nlock.homeManagerModules.default
    inputs.way-edges.homeManagerModules.default
  ];
}
