{ system, inputs }:
final: prev: {
  tars = inputs.tars.packages.${system}.default;
}
