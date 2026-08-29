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
    audio.enable = true;
    boot.type = "efi";
    core = {
      enable = true;
      tailscale = true;
    };
    power = {
      enable = true;
      profile = "laptop";
    };
    print.enable = true;
    fs = {
      type = "efi-unified";
      swap = {
        enable = true;
        type = "partition";
      };
    };
    hardware.bluetooth.enable = true;
    hardware.firmware.enable = true;
    hardware.graphics = {
      enable = true;
      type = "intel";
    };
    mango.enable = true;
    sddm.enable = true;
    security.pam = {
      services = [
        "swaylock"
        "nlock"
      ];
      keyring = true;
    };
    update.enable = true;
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
