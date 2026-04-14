{
  lib,
  host,
  pkgs,
  inputs,
  ...
}:

{
  mkSystem =
    { name, stateVersion }:
    let
      sysConfig = import ../systems/${name} {
        inherit pkgs inputs;
      };
      cfg = lib.attrsets.recursiveUpdate sysConfig {
        inherit name stateVersion;
        hostMeta.hostname = name;
      };
    in
    host.mkHost cfg;
}
