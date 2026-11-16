final: prev: {
  niko-cursors = prev.stdenv.mkDerivation (finalAttrs: {
    pname = "niko-cursors";
    version = "0.1";

    src = prev.fetchurl {
      url = "https://obj.ngill.net/other/Niko-cursors-v0.1.tar.gz";
      hash = "sha256-18K9+DJgvrHwBYd/V01e4dQILYyv6TaMWUYczwgxhA0=";
    };

    buildPhase = ''
      mkdir -p $out/share/icons/Niko
      cp -r ./* $out/share/icons/Niko/
    '';
  });
}
