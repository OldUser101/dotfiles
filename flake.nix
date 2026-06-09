{
  description = "OldUser101 NixOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    naersk = {
      url = "github:nix-community/naersk";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nlock.url = "github:OldUser101/nlock/v0.1.6";

    lic = {
      url = "github:OldUser101/lic";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    olduser101-sway.url = "github:OldUser101/sway";

    way-edges = {
      url = "github:way-edges/way-edges/0.12.1";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    onyx.url = "github:OldUser101/onyx";

    git-hooks = {
      url = "github:cachix/git-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    lanzaboote = {
      url = "github:nix-community/lanzaboote/v1.0.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      naersk,
      nlock,
      onyx,
      olduser101-sway,
      git-hooks,
      agenix,
      ...
    }@inputs:
    let
      system = "x86_64-linux";
      lib = nixpkgs.lib;

      overlays = [
        nlock.overlays.nlock
        onyx.overlays.onyx
        olduser101-sway.overlays.sway-unwrapped
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

      preCommitCheck = git-hooks.lib.${system}.run {
        src = ./.;
        hooks.nixfmt.enable = true;
      };
    in
    {
      nixosConfigurations = {
        natha-nixos0 = systems.mkSystem {
          name = "natha-nixos0";
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
