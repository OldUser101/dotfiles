{ system, inputs }:
final: prev: {
  way-edges = inputs.way-edges.packages.${system}.way-edges.overrideAttrs (old: {
    patches = (old.patches or [ ]) ++ [
      ../patches/way-edges/bg-color.patch
      ../patches/way-edges/fix-ring-suffix.patch
    ];
  });
}
