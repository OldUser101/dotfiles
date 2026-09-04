{
  system,
  inputs,
  pkgs,
  home-manager,
  lib,
  user,
  ...
}:

with builtins;
{
  mkHost =
    {
      name,
      initrdMods,
      kernelMods,
      kernelParams,
      kernelPackage,
      systemConfig,
      users,
      cpuCores,
      stateVersion,
      extraPackages ? [ ],
      extraNixosModules ? [ ],
      extraHomeManagerModules ? [ ],
      hostMeta ? { },
    }:
    let
      sysUsers = (map (u: user.mkSystemUser u) users);
    in
    lib.nixosSystem {
      inherit system;

      specialArgs = { inherit hostMeta; };

      modules = [
        ../modules/system
      ]
      ++ sysUsers
      ++ extraNixosModules
      ++ [
        {
          networking.hostName = "${name}";
          networking.networkmanager.enable = true;
          networking.nameservers = [
            "1.1.1.1"
            "1.0.0.1"
            "9.9.9.9"
          ];

          boot.initrd.availableKernelModules = initrdMods;
          boot.kernelModules = kernelMods;
          boot.kernelParams = kernelParams;
          boot.kernelPackages = kernelPackage;

          nixpkgs.pkgs = pkgs;
          nix.settings = {
            max-jobs = lib.mkDefault cpuCores;
            trusted-users = [ "@wheel" ];
            substituters = [
              "https://olduser101.cachix.org"
            ];
            trusted-public-keys = [
              "olduser101.cachix.org-1:DVqbs5NGDnwbI2VayMHpy/4mHF7O7mYhMuhjvT6fOLI="
            ];
          };

          environment.systemPackages = [
            # this is always wanted for flake management
            inputs.tack.packages.${system}.default
          ]
          ++ extraPackages;

          system.stateVersion = stateVersion;

          olduser101 = systemConfig;
        }

        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;

          home-manager.extraSpecialArgs = { inherit hostMeta; };

          home-manager.sharedModules = extraHomeManagerModules;

          home-manager.users = listToAttrs (
            map (u: {
              name = u.name;
              value = import ../modules/home/${u.name} {
                inherit stateVersion;
                hostName = name;
              };
            }) users
          );
        }
      ];
    };
}
