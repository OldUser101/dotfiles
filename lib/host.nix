{ system, pkgs, home-manager, lib, user, ... }:

with builtins;
{
  mkHost = { name, NICs, initrdMods, kernelMods, kernelParams, kernelPackage,
    systemConfig, users, cpuCores, wifi ? [], stateVersion,
    hostMeta ? {}}:
  let
    networkCfg = listToAttrs (map (n: {
      name = n; value = { useDHCP = true; };
    }) NICs);

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
        networking.interfaces = networkCfg;
        networking.wireless.interfaces = wifi;

        networking.networkmanager.enable = true;
        networking.useDHCP = false;

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
