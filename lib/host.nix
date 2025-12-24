{ system, pkgs, home-manager, lib, user, ... }:

with builtins;
{
  mkHost = { name, NICs, initrdMods, kernelMods, kernelParams, kernelPackage,
    systemConfig, users, hostPlatform, cpuCores, wifi ? [], stateVersion }:
  let
    networkCfg = listToAttrs (map (n: {
      name = "${n}"; value = { useDHCP = true; };
    }) NICs);

    userCfg = {
      inherit name NICs systemConfig cpuCores;
    };

    sysUsers = (map (u: user.mkSystemUser u) users);
  in lib.nixosSystem {
    inherit system;

    modules = [
      {
        imports = [ ../modules/system ] ++ sysUsers;

        olduser101 = systemConfig;

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
      }
    ];
  };
}
