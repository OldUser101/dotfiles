{
  pkgs,
  lib,
  util,
  modulesPath,
  config,
}:
{
  waitOnline ? false,
  tailscale ? false,
  sshd ? null,
}:
lib.mkMerge [
  {
    systemd.services.NetworkManager-wait-online.enable = waitOnline;
    services.tailscale.enable = tailscale;
  }

  (
    if (sshd != null) then
      (
        (import ./sshd {
          inherit
            pkgs
            lib
            util
            modulesPath
            config
            ;
        })
          sshd
      )
    else
      { }
  )
]
