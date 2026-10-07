final: prev: {
  rbdoom-3-bfg = prev.rbdoom-3-bfg.overrideAttrs (old: {
    patches = (old.patches or [ ]) ++ [
      ../patches/rbdoom-3-bfg/0001-add-TOOLS-option-to-disable-extra-tools.patch
    ];

    cmakeFlags = old.cmakeFlags ++ [
      "-DTOOLS=OFF"
    ];
  });
}
