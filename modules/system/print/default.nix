{
  pkgs,
  ...
}:
{ }:
{
  services.printing = {
    enable = true;
    drivers = with pkgs; [
      # i only have one printer..
      cnijfilter2
    ];
  };

  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };
}
