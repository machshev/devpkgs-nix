# SPDX-License-Identifier: MIT
{
  description = "Dev environment Nix Packages";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    flake-utils.url = "github:numtide/flake-utils";

    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-facter-modules.url = "github:numtide/nixos-facter-modules";

    # For command-not-found, need this since we get rid of all channels
    flake-programs-sqlite = {
      url = "github:wamserma/flake-programs-sqlite";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.4.1";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };

    deploy-rs = {
      url = "github:serokell/deploy-rs";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.utils.follows = "flake-utils";
    };
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
    ...
  } @ inputs: let
    # This could just be inputs.deploy-rs, but doing so will require rebuild instead of using binary cache.
    # See instruction from the upstream repo: https://github.com/serokell/deploy-rs
    deploy-rs.lib = flake-utils.lib.eachDefaultSystemMap (
      system:
        (import nixpkgs {
          inherit system;
          overlays = [
            inputs.deploy-rs.overlay
            (final: prev: {
              deploy-rs = {
                inherit (nixpkgs.legacyPackages.${prev.system}) deploy-rs;
                lib = prev.deploy-rs.lib;
              };
            })
          ];
        })
        .deploy-rs
        .lib
    );

    no_system_outputs = rec {
      nixosModules.machshev = import ./modules {inherit self inputs;};

      nixosConfigurations = {
        machshev = nixpkgs.lib.nixosSystem {
          specialArgs = {inherit inputs;};
          modules = [
            ./hosts/machshev/configuration.nix
            {config.facter.reportPath = ./hosts/machshev/facter.json;}
            inputs.nixos-facter-modules.nixosModules.facter
            inputs.home-manager.nixosModules.default
            nixosModules.machshev
          ];
        };
        machshev-laptop = nixpkgs.lib.nixosSystem {
          specialArgs = {inherit inputs;};
          modules = [
            ./hosts/machshev-laptop/configuration.nix
            inputs.home-manager.nixosModules.default
            nixosModules.machshev
          ];
        };
        qatan = nixpkgs.lib.nixosSystem {
          specialArgs = {inherit inputs;};
          modules = [
            ./hosts/qatan
            {config.facter.reportPath = ./hosts/qatan/facter.json;}
            inputs.nixos-facter-modules.nixosModules.facter
            inputs.home-manager.nixosModules.default
            nixosModules.machshev
          ];
        };
      };

      deploy = {
        nodes =
          builtins.mapAttrs (name: _: {
            hostname = name;
            profiles.system = {
              user = "root";
              path = deploy-rs.lib.${self.nixosConfigurations.${name}.pkgs.system}.activate.nixos self.nixosConfigurations.${name};
            };
          }) {
            qatan = {};
          };
      };
    };

    all_system_outputs = flake-utils.lib.eachDefaultSystem (system: let
      pkgs = import nixpkgs {
        inherit system;
      };
      machshev_pkgs = import ./pkgs {inherit pkgs inputs;};
    in {
      packages = flake-utils.lib.filterPackages system machshev_pkgs;
      devShells = {
        hardware-hacking = pkgs.mkShell {
          name = "Hardware Hacking";
          packages = with pkgs; [
            sigrok-cli
            pulseview
          ];
        };
      };
      formatter = pkgs.alejandra;
    });
  in
    # Recursive-merge attrsets to compose the final flake outputs attrset.
    builtins.foldl' nixpkgs.lib.attrsets.recursiveUpdate {} [
      no_system_outputs
      all_system_outputs
    ];
}
