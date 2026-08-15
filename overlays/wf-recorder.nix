final: prev: {
  wf-recorder = prev.wf-recorder.override {
    # until #552231
    ffmpeg = prev.ffmpeg_8;
  };
}
