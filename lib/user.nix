{ pkgs, home-manager, lib, system, overlays, ... }:

with builtins;
{
  mkHMUser = { userConfig, username, stateVersion }:
    home-manager.lib.homeManagerConfiguration {
      inherit system username pkgs;
      stateVersion = stateVersion;
      configuration =
        let
          trySettings = tryEval (fromJSON (readFile /etc/hmsystemdata.json));
          machineData = if trySettings.success then trySettings.value else {};

          machineModule = { pkgs, config, lib, ... }: {
            options.machineData = lib.mkOption {
              default = {};
              description = "Settings passed from NixOS configuration";
            };

            config.machineData = machineData;
          };
        in {
          olduser101 = userConfig;

          nixpkgs.overlays = overlays;
          nixpkgs.config.allowUnfree = true;

          systemd.user.startServices = true;
          home.stateVersion = stateVersion;
          home.username = username;
          home.homeDirectory = "/home/${username}";

          imports = [
            ../modules/user/core
            machineModule
          ] ++ lib.optional (fileExists ../modules/user/${username}) [
            ../modules/user/${username}
          ];
        };
      homeDirectory = "/home/${username}";
    };

  mkSystemUser = { name, groups, uid, shell, ... }:
  {
    users.users."${name}" = {
      name = name;
      isNormalUser = true;
      isSystemUser = false;
      extraGroups = groups;
      uid = uid;
      shell = shell;
    };
  };
}
