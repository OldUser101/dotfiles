{ system, inputs, ... }:

[
  (import ./mpv.nix)
  (import ./kak-jj.nix)
  (import ./wl-clipboard-kak.nix)
  (import ./sidetree.nix)
  (import ./lic.nix { inherit system inputs; })
  (import ./way-edges.nix { inherit system inputs; })
  (import ./htop.nix)
  (import ./wf-recorder.nix)
]
