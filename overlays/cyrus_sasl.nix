final: prev: {
  cyrus_sasl = prev.cyrus_sasl.overrideAttrs (old: {
    src = prev.fetchFromGitHub {
      owner = "OldUser101";
      repo = "cyrus-sasl";
      rev = "4fd8f6f7bba07bdd329ae18d5e7f15ab790b0e69";
      hash = "sha256-W/Es1SenwrHcOPUHYWAEo7bFT0nhIn0HD2dNWfDKpsM=";
    };

    patches = [ ];
  });
}
