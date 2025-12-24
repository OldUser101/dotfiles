{
  description = "OldUser101 NixOS configuration";

  inputs = {
    nixpkgs.url = github:NixOS/nixpkgs/nixos-unstable;

    home-manager = {
      url = github:nix-community/home-manager;
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ { self, nixpkgs, home-manager }:
  let
    inherit (nixpkgs) lib;

    util = import ./lib {
      inherit system pkgs home-manager lib; overlays = (pkgs.overlays);
    };

    inherit (util) user;
    inherit (util) host;

    pkgs = import nixpkgs {
      inherit system;
      config.allowUnfree = true;
      overlays = [];
    };

    system = "x86_64-linux";
  in {
    homeManagerConfigurations = {
      natha = user.mkHMUser {
        username = "natha";
        userConfig = {
          fonts.enable = true;
        };
        stateVersion = "25.11";
      };
    };

    nixosConfigurations = {
      natha-nixos0 = host.mkHost {
        name = "natha-nixos0";
        NICs = [ "wlp0s20f3" ];
        kernelPackage = pkgs.linuxPackages_latest;
        initrdMods = [ "xhci_pci" "nvme" "usbhid" "usb_storage" "sd_mod" "sdhci_pci" ];
        kernelMods = [ "kvm-intel" ];
        kernelParams = [];
        systemConfig = {
          audio.enable = true;
          boot.type = "efi";
          core.enable = true;
          fs = {
            type = "efi-default";
            swap = {
              enable = true;
              type = "partition";
            };
          };
          hardware.bluetooth.enable = true;
          hardware.graphics = {
            enable = true;
            type = "intel";
          };
          sddm.enable = true;
          security.pam.services = [ "swaylock" "nlock" ];
          shells.zsh.enable = true;
          sway.enable = true;
        };
        users = [
          {
            name = "natha";
            groups = [ "wheel" ];
            uid = 1000;
            shell = pkgs.zsh;
          }
        ];
        cpuCores = 8;
        hostPlatform = "x86_64-linux";
        stateVersion = "25.11";
      };
    };
  };
}
