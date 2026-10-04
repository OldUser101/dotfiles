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
    audio = { };

    boot = {
      type = "efi";
      configLimit = 3;
    };

    fs = {
      type = "efi-unified";
      swap.type = "partition";
    };

    hardware = {
      bluetooth = { };
      firmware = { };
      graphics.type = "intel";
    };

    i18n = { };
    misc.update = { };
    network.tailscale = true;
    power.profile = "laptop";
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
  cpuCores = 8;
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
