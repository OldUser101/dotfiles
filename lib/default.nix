{ pkgs, home-manager, system, lib, ... }:

rec {
  user = import ./user.nix { };
  host = import ./host.nix { inherit system pkgs home-manager lib user; };
}
