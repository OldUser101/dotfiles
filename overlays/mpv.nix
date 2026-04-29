final: prev: {
  mpv = prev.mpv.override {
    # disable youtube support, i don't use it, and #511900
    youtubeSupport = false;
  };
}
