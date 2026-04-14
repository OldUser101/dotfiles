{
  pkgs,
  home-manager,
  system,
  lib,
  inputs,
  ...
}:

rec {
  user = import ./user.nix { };
  host = import ./host.nix {
    inherit
      system
      inputs
      pkgs
      home-manager
      lib
      user
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
