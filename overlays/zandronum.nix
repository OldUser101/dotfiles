final: prev: {
  zandronum = prev.stdenv.mkDerivation (finalAttrs: {
    pname = "zandronum";
    version = "3.2.1";

    src = prev.fetchzip {
      url = "https://zandronum.com/downloads/zandronum3.2.1-linux-x86_64.tar.bz2";
      hash = "sha256-EYMx5U3DhyJsiYSSwvfFgGeCC+e5LpLUqZkEcqcH8PU=";
      stripRoot = false;
    };

    buildInputs = with prev; [
      gtk2
      glib
      SDL
      libGL
      libGLU
      zlib
      libjpeg8
      bzip2
      openssl
      libopus
    ];

    nativeBuildInputs = with prev; [
      autoPatchelfHook
      makeWrapper
    ];

    installPhase = ''
      mkdir -p $out/bin
      mkdir -p $out/lib/zandronum
      cp ./zandronum $out/lib/zandronum/
      cp ./*.so $out/lib/zandronum/
      cp ./*.pk3 $out/lib/zandronum/
      makeWrapper $out/lib/zandronum/zandronum $out/bin/zandronum

      addAutoPatchelfSearchPath $out/lib/zandronum
    '';
  });
}
