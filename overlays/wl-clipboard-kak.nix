self: system: final: prev: {
  wl-clipboard-kak =
    prev.kakouneUtils.buildKakounePluginFRom2Nix {
      pname = "wl-clipboard-kak";
      version = "2025-12-20";

      src = prev.fetchFromGitHub {
        owner = "OldUser101";
        repo = "kak-wl-clipboard";
        rev = "e07b0b58cf9d8548271b5bb52e7e6e40efec2bd9";
        sha256 = "00iqdz71aphm8k0b897mbpxhj84r6fl8j901jklcv7ardznrhb03";
      };

      meta.homepage = "https://github.com/OldUser101/kak-wl-clipboard";

      buildInputs = [
        prev.wl-clipboard
      ];
    };
}

