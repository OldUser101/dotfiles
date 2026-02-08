final: prev: {
  kakounePlugins = prev.kakounePlugins // {
    kak-jj =
      prev.kakouneUtils.buildKakounePluginFrom2Nix {
        pname = "kak-jj";
        version = "2025-12-24";

        src = prev.fetchFromGitHub {
          owner = "OldUser101";
          repo = "kak-jj";
          rev = "fb334a0a955be231269ee17d75005104e295ab14";
          sha256 = "0j4wffh5fi4lgcxz69w12bbwjsncb83mfpk788aw024p9709gyf2";
        };

        meta.homepage = "https://github.com/OldUser101/kak-jj";
      };
  };
}
