{
  ...
}:
{
  users ? [ ],
}:
{
  services.openssh = {
    enable = true;
    openFirewall = true;
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      PermitRootLogin = "no";
      MaxAuthTries = 3;
      AllowUsers = users;
      PerSourcePenalties = "crash:3600s authfail:3600s max:86400s";
    };
  };
}
