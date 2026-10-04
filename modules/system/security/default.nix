{
  pkgs,
  lib,
  util,
  modulesPath,
  config,
}:
{
  sudo ? null,
  pam ? null,
}:
lib.mkMerge [
  (
    if (sudo != null) then
      (
        (import ./sudo {
          inherit
            pkgs
            lib
            util
            modulesPath
            config
            ;
        })
          sudo
      )
    else
      { }
  )

  (
    if (pam != null) then
      (
        (import ./pam {
          inherit
            pkgs
            lib
            util
            modulesPath
            config
            ;
        })
          pam
      )
    else
      { }
  )
]
