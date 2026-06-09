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
    boot.type = "efi-secure";
    core = {
      enable = true;
      tailscale = true;
    };
    power = {
      enable = true;
      profile = "laptop";
    };
    print.enable = true;
    programs.steam = true;
    fs = {
      type = "efi-default";
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
    sddm.enable = true;
    security.pam = {
      services = [
        "swaylock"
        "nlock"
      ];
      keyring = true;
    };
    sway.enable = true;
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
  ];
  extraHomeManagerModules = [
    inputs.nlock.homeManagerModules.default
    inputs.way-edges.homeManagerModules.default
    inputs.agenix.homeManagerModules.default
  ];
}
