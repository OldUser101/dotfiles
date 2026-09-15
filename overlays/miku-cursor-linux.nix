final: prev: {
  miku-cursor-linux = prev.stdenv.mkDerivation (finalAttrs: {
    pname = "miku-cursor-linux";
    version = "1.2.6";

    src = prev.fetchurl {
      url = "https://github.com/supermariofps/hatsune-miku-windows-linux-cursors/releases/download/${finalAttrs.version}/miku-cursor-linux.tar.xz";
      hash = "sha256-ahPuw5KJN1dbw1Q1QQ8nZBDImSRdDKmMf54cwj8fJok=";
    };

    buildPhase = ''
      mkdir -p $out/share/icons/miku-cursor-linux
      cp -r ./* $out/share/icons/miku-cursor-linux/
    '';
  });
}
