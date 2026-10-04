{
  lib,
  ...
}:
{
  extraSettings ? { },
}:
{
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = lib.mkMerge [
      {
        General = {
          Experimental = true;
          FastConnectable = true;
        };

        Policy = {
          AutoEnable = true;
        };
      }
      extraSettings
    ];
  };
}
