self: system: final: prev: {
  sidetree =
    prev.naersk.buildPackage {
      pname = "sidetree";
      version = "0.10.0";

      src = prev.fetchFromGitHub {
        owner = "topisani";
        repo = "sidetree";
        rev = "80be63211e67dd4cfe2b938558455d8c2b9a14f6";
        sha256 = "0c0r5kf10w77y3w9rwwj2par9i7xh5w4xbsy06v1c4bn9whplh0q";
      };
    };
}
