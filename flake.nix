{
  description = "OldUser101 NixOS configuration";

  inputs = {
    nixpkgs.url = github:NixOS/nixpkgs/nixos-unstable;

    home-manager = {
      url = github:nix-community/home-manager;
      inputs.nixpkgs.follows = "nixpkgs";
    };

    naersk = {
      url = "github:nix-community/naersk";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nlock = {
      url = "github:OldUser101/nlock";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.naersk.follows = "naersk";
    };

    tars = {
      url = "github:OldUser101/tars";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.naersk.follows = "naersk";
    };
  };

  outputs = inputs @ { self, nixpkgs, home-manager, naersk, ... }:
  let
    system = "x86_64-linux";
    lib = nixpkgs.lib;

    overlays = import ./overlays { inherit system inputs; };

    pkgs = import nixpkgs {
      inherit system overlays;
      config.allowUnfree = true;
    };

    util = import ./lib {
      inherit system pkgs home-manager lib;
    };

    inherit (util) user host;
  in {
    nixosConfigurations = {
      natha-nixos0 = host.mkHost {
        name = "natha-nixos0";
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
          hardware.firmware.enable = true;
          hardware.graphics = {
            enable = true;
            type = "intel";
          };
          sddm.enable = true;
          security.pam.services = [ "swaylock" "nlock" ];
          shells.zsh.enable = true;
          sway.enable = true;
        };
        hostMeta = {
          dotfiles = "/home/natha/.config/olduser101";
          hostname = "natha-nixos0";
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
        stateVersion = "25.11";
      };
    };
  };
}
