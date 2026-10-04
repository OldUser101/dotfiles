{
  system,
  inputs,
  pkgs,
  home-manager,
  lib,
  user,
  util,
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
      systemConfig ? { },
      users,
      cpuCores,
      stateVersion,
      extraConfig ? { },
      extraPackages ? [ ],
      extraNixosModules ? [ ],
      extraHomeManagerModules ? [ ],
      hostMeta ? { },
    }:
    let
      sysUsers = (map (u: user.mkSystemUser u) users);

      sysModulesPath = ../modules/system;

      sysConfig =
        config:
        lib.mkMerge (
          builtins.map (
            c:
            (import "${sysModulesPath}/${c.name}" {
              inherit
                pkgs
                lib
                util
                config
                ;
              modulesPath = sysModulesPath;
            })
              c.value
          ) (lib.attrsToList systemConfig)
        );
    in
    lib.nixosSystem {
      inherit system;

      specialArgs = { inherit hostMeta; };

      modules =
        sysUsers
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
              experimental-features = [
                "nix-command"
                "flakes"
                "pipe-operators"
              ];
            };

            environment.systemPackages =
              with pkgs;
              [
                curl
                iw
                tree
                lsof
                git
                wget
                vim

                # surprisingly useful
                nqdc
              ]
              ++ [
                # this is always wanted for flake management
                inputs.tack.packages.${system}.default
              ]
              ++ extraPackages;

            system.stateVersion = stateVersion;
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

          ({ config, ... }: sysConfig config)
        ]
        ++ extraNixosModules;
    };
}
