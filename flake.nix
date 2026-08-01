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
          stateVersion = "25.11";
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

      devShells.${system}.default = pkgs.mkShell {
        inherit (preCommitCheck) shellHook;
        buildInputs = preCommitCheck.enabledPackages;
      };
    };
}
