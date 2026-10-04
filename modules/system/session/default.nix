{
  pkgs,
  lib,
  util,
  modulesPath,
  config,
}:
{
  sddm ? null,
}:
lib.mkMerge [
  (
    if (sddm != null) then
      (
        (import ./sddm {
          inherit
            pkgs
            lib
            util
            modulesPath
            config
            ;
        })
          sddm
      )
    else
      { }
  )
]
