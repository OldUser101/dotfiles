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
    audio.enable = true;
    boot = {
      type = "efi";
      configurationLimit = 3;
    };
    core = {
      enable = true;
      tailscale = true;
    };
    print.enable = true;
    programs.steam = true;
    fs = {
      type = "efi-default";
      dataType = "default";
      swap = {
        enable = true;
        type = "partition";
      };
    };
    hardware.bluetooth.enable = true;
    hardware.firmware.enable = true;
    hardware.graphics = {
      enable = true;
      type = "amd";
      lact = true;
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
  ];
  extraHomeManagerModules = [
    inputs.nlock.homeManagerModules.default
    inputs.way-edges.homeManagerModules.default
    inputs.agenix.homeManagerModules.default
    inputs.wl-overlay.homeManagerModules.wl-overlay
  ];
}
