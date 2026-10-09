{ system, inputs, ... }:

[
  (import ./mpv.nix)
  (import ./kak-jj.nix)
  (import ./wl-clipboard-kak.nix)
  (import ./sidetree.nix)
  (import ./cyrus_sasl.nix)
  (import ./rbdoom-3-bfg.nix)
  (import ./miku-cursor-linux.nix)
  (import ./lic.nix { inherit system inputs; })
  (import ./way-edges.nix { inherit system inputs; })
]
