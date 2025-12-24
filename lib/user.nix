{ pkgs, home-manager, lib, system, overlays, ... }:

{
  mkHMUser = { userConfig, username, stateVersion }:
    home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      modules = [
        {
          olduser101 = userConfig;

          nixpkgs = {
            inherit overlays;
            config.allowUnfree = true;
          };

          home = {
            inherit username stateVersion;
            homeDirectory = "/home/${username}";
          };

          systemd.user.startServices = true;
        }
        ../modules/user/core
      ] ++ lib.optional (builtins.pathExists ../modules/user/${username})
        ../modules/user/${username};
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
