{ system, inputs }:
final: prev: {
  lic = inputs.lic.packages.${system}.default;
}
