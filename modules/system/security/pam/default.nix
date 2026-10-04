{
  ...
}:
{
  services ? [ ],
}:
{
  security.pam.services = builtins.listToAttrs (
    builtins.map (s: {
      name = s;
      value = { };
    }) services
  );
}
