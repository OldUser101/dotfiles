final: prev: {
  rbdoom-3-bfg = prev.rbdoom-3-bfg.overrideAttrs (old: {
    src = prev.fetchFromGitHub {
      owner = "OldUser101";
      repo = "RBDOOM-3-BFG";
      rev = "b575294a754ea3e780b80399d959f7962ad04f4e";
      hash = "sha256-GGOQ8ayYsBw2onKgVLfNpSQonzMSwYRtzF3WSz5WEtY=";
      fetchSubmodules = true;
    };

    cmakeFlags = old.cmakeFlags ++ [
      "-DTOOLS=OFF"
      "-DDISCORD_RPC=ON"
      "-DCMAKE_POLICY_VERSION_MINIMUM=3.5"
    ];
  });
}
