{ system, inputs, ... }:

[
  # Needed by other overlays, should be first
  (import ./naersk.nix { inherit system inputs; })

  (import ./kak-jj.nix)
  (import ./wl-clipboard-kak.nix)
  (import ./sidetree.nix)
  (import ./nlock.nix { inherit system inputs; })
  (import ./tars.nix { inherit system inputs; })
]
