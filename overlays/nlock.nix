{ system, inputs }:
final: prev: {
  nlock = inputs.nlock.packages.${system}.default;
}
