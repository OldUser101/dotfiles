{
  description = "OldUser101 NixOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    naersk = {
      url = "github:nix-community/naersk";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nlock = {
      url = "github:OldUser101/nlock";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    lic = {
      url = "git+https://tangled.org/nathanjgill.uk/lic";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      naersk,
      nlock,
      ...
    }@inputs:
    let
      system = "x86_64-linux";
      lib = nixpkgs.lib;

      overlays = [
        nlock.overlays.nlock
      ]
      ++ (import ./overlays { inherit system inputs; });

      pkgs = import nixpkgs {
        inherit system overlays;
        config.allowUnfree = true;
      };

      util = import ./lib {
        inherit
          system
          inputs
          pkgs
          home-manager
          lib
          ;
      };

      inherit (util) user host;
    in
    {
      nixosConfigurations = {
        natha-nixos0 = host.mkHost {
          name = "natha-nixos0";
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
          hostMeta = {
            localDotfiles = "/home/natha/.config/olduser101";
            hostname = "natha-nixos0";
          };
          users = [
            {
              name = "natha";
              groups = [
                "wheel"
                "dialout"
              ];
              uid = 1000;
              shell = pkgs.bash;
            }
          ];
          cpuCores = 8;
          extraNixosModules = [ inputs.nlock.nixosModules.default ];
          extraHomeManagerModules = [ inputs.nlock.homeManagerModules.default ];
          stateVersion = "25.11";
        };
      };
    };
}
