{
  pkgs,
  home-manager,
  system,
  lib,
  inputs,
  ...
}:

rec {
  util = import ./util.nix;
  user = import ./user.nix { };
  host = import ./host.nix {
    inherit
      system
      inputs
      pkgs
      home-manager
      lib
      user
      util
      ;
  };
  systems = import ./systems.nix {
    inherit
      lib
      host
      pkgs
      inputs
      ;
  };
}
