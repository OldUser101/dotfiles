{
  lib,
  ...
}:
{
  mango ? false,
  sway ? false,
}:
lib.mkMerge [
  (lib.mkIf mango {
    security.polkit.enable = true;
    programs.dconf.enable = true;
    programs.mango.enable = true;
  })

  (lib.mkIf sway {
    security.polkit.enable = true;
    programs.sway.enable = true;
  })
]
