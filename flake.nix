{
  description = "OldUser101 NixOS configuration";

  outputs =
    {
      self,
      ...
    }@args:
    let
      inputs = import ./.tack {
        overrides = args.tackOverrides or { };
      };

      inherit (inputs) nixpkgs home-manager;

      system = "x86_64-linux";
      lib = nixpkgs.lib;

      overlays = [
        inputs.nlock.overlays.nlock
        inputs.onyx.overlays.onyx
        inputs.sway.overlays.sway-unwrapped
        inputs.wl-overlay.overlays.wl-overlay
      ]
      ++ (import ./overlays { inherit system inputs; });

      pkgs = import nixpkgs {
        inherit system overlays;
        config.allowUnfree = true;
      };

      util = import ./lib {
        inherit
          system
          inputs
          pkgs
          home-manager
          lib
          ;
      };

      inherit (util) systems;

      preCommitCheck = inputs.git-hooks.lib.${system}.run {
        src = ./.;
        hooks.nixfmt.enable = true;
      };
    in
    {
      nixosConfigurations = {
        natha-e2hyref = systems.mkSystem {
          name = "natha-e2hyref";
          stateVersion = "26.05";
        };

        natha-76k4epg = systems.mkSystem {
          name = "natha-76k4epg";
          stateVersion = "25.11";
        };

        natha-vrdhq85 = systems.mkSystem {
          name = "natha-vrdhq85";
          stateVersion = "26.05";
        };

        natha-5334qwx = systems.mkSystem {
          name = "natha-5334qwx";
          stateVersion = "25.11";
        };
      };

      packages.${system}.gen-suffix = pkgs.stdenv.mkDerivation {
        name = "gen-suffix";

        src = ./.;

        buildInputs = with pkgs; [
          gcc
          gnumake
        ];

        buildPhase = ''
          make tools/gen-suffix
        '';

        installPhase = ''
          mkdir -p $out/bin
          cp tools/gen-suffix $out/bin/
        '';
      };

      devShells.${system}.default = pkgs.mkShell {
        inherit (preCommitCheck) shellHook;
        buildInputs = [
          self.packages.${system}.gen-suffix
        ]
        ++ preCommitCheck.enabledPackages;
      };
    };
}
