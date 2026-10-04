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

    fs = {
      type = "efi-baytrail";
      swap.type = "partition";
    };

    hardware = {
      firmware = { };
      graphics.type = "intel";
    };

    i18n = { };
    power.profile = "laptop";

    security = {
      sudo = { };
      pam.services = [ "swaylock" ];
    };

    wayland.sway = { };
  };
  hostMeta.localDotfiles = "/home/natha/.config/olduser101";
  users = [
    {
      name = "natha";
      groups = [
        "wheel"
        "dialout"
        "networkmanager"
      ];
      uid = 1000;
      shell = pkgs.bash;
    }
  ];
  cpuCores = 4;
  extraNixosModules = [
    inputs.nlock.nixosModules.default
  ];
  extraHomeManagerModules = [
    inputs.nlock.homeManagerModules.default
    inputs.way-edges.homeManagerModules.default
    inputs.wl-overlay.homeManagerModules.wl-overlay
  ];
}
