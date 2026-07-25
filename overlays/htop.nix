final: prev: {
  htop = prev.htop.overrideAttrs (old: {
    patches = (old.patches or [ ]) ++ [
      ../patches/htop/0001-exit-follow-mode-when-search-or-filter-is-cancelled.patch
    ];
  });
}
