{
  lib,
  host,
  pkgs,
  inputs,
  ...
}:

{
  mkSystem =
    {
      name,
      stateVersion,
      system,
    }:
    let
      sysConfig = import ../systems/${name} {
        inherit pkgs inputs system;
      };
      cfg = lib.attrsets.recursiveUpdate sysConfig {
        inherit name stateVersion;
        hostMeta.hostname = name;
      };
    in
    host.mkHost cfg;
}
