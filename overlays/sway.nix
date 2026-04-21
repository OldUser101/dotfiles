{ inputs }:

final: prev: {
  sway-unwrapped = prev.sway-unwrapped.overrideAttrs (old: {
    src = inputs.olduser101-sway;
    version = "olduser101-git-${inputs.olduser101-sway.shortRev or "dirty"}";
  });
}
