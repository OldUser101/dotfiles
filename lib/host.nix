{ system, pkgs, home-manager, lib, user, ... }:

with builtins;
{
  mkHost = { name, initrdMods, kernelMods, kernelParams, kernelPackage,
    systemConfig, users, cpuCores, stateVersion,
    hostMeta ? {}}:
  let
    sysUsers = (map (u: user.mkSystemUser u) users);
  in lib.nixosSystem {
    inherit system;

    specialArgs = { inherit hostMeta; };

    modules = [
      ../system
    ] ++ sysUsers
    ++ [
      {
        networking.hostName = "${name}";
        networking.networkmanager.enable = true;

        boot.initrd.availableKernelModules = initrdMods;
        boot.kernelModules = kernelMods;
        boot.kernelParams = kernelParams;
        boot.kernelPackages = kernelPackage;

        nixpkgs.pkgs = pkgs;
        nix.settings.max-jobs = lib.mkDefault cpuCores;

        system.stateVersion = stateVersion;

        olduser101 = systemConfig;
      }

      home-manager.nixosModules.home-manager
      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;

        home-manager.extraSpecialArgs = { inherit hostMeta; };

        home-manager.users = listToAttrs (map (u: {
          name = u.name;
          value = import ../home/${u.name};
        }) users);
      }
    ];
  };
}
