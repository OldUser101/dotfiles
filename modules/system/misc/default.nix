{
  pkgs,
  lib,
  util,
  modulesPath,
  config,
}:
{
  sshAgent ? true,
  steam ? false,
  disableSpeechDispatcher ? true,
  gnomeKeyring ? true,
  update ? null,
}:
lib.mkMerge [
  {
    programs.ssh.startAgent = sshAgent;
    security.pam.services.login.enableGnomeKeyring = gnomeKeyring;
  }

  (lib.mkIf steam {
    programs.steam = {
      enable = true;
      extraPackages = with pkgs; [
        mangohud
      ];
      extraCompatPackages = with pkgs; [
        proton-ge-bin
        dwproton-bin
      ];
    };
  })

  (lib.mkIf disableSpeechDispatcher {
    services.speechd.enable = lib.mkForce false;
  })

  (
    if (update != null) then
      (
        (import ./update {
          inherit
            pkgs
            lib
            util
            modulesPath
            config
            ;
        })
          update
      )
    else
      { }
  )
]
