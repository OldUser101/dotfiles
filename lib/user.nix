{ ... }:

{
  mkSystemUser =
    {
      name,
      groups,
      uid,
      shell,
      sshKeys,
      ...
    }:
    {
      users.users."${name}" = {
        name = name;
        isNormalUser = true;
        isSystemUser = false;
        extraGroups = groups;
        uid = uid;
        shell = shell;
        openssh.authorizedKeys.keys = sshKeys;
      };
    };
}
