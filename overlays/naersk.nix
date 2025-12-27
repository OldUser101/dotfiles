{ system, inputs }:
final: prev: {
  naersk = inputs.naersk.lib.${system};
}
