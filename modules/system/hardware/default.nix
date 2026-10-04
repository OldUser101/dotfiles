{
  pkgs,
  lib,
  util,
  modulesPath,
  config,
}:
{
  bluetooth ? null,
  firmware ? null,
  graphics ? null,
}:
lib.mkMerge [
  (
    if (bluetooth != null) then
      (
        (import ./bluetooth {
          inherit
            pkgs
            lib
            util
            modulesPath
            config
            ;
        })
          bluetooth
      )
    else
      { }
  )

  (
    if (firmware != null) then
      (
        (import ./firmware {
          inherit
            pkgs
            lib
            util
            modulesPath
            config
            ;
        })
          firmware
      )
    else
      { }
  )

  (
    if (graphics != null) then
      (
        (import ./graphics {
          inherit
            pkgs
            lib
            util
            modulesPath
            config
            ;
        })
          graphics
      )
    else
      { }
  )
]
