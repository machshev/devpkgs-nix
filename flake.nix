# SPDX-License-Identifier: MIT
{
  description = "Dev environment Nix Packages";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    flake-utils.url = "github:numtide/flake-utils";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
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
      url = "github:nix-community/lanzaboote/v0.4.2";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
    ...
  } @ inputs: let
    no_system_outputs = {
      nixosModules.machshev = import ./modules {inherit self inputs;};
    };

    all_system_outputs = flake-utils.lib.eachDefaultSystem (system: let
      pkgs = import nixpkgs {
        inherit system;
      };
      machshev_pkgs = import ./pkgs {inherit pkgs inputs;};
    in {
      packages = flake-utils.lib.filterPackages system machshev_pkgs;
      devShells = {
        re-hacking = pkgs.mkShell {
          name = "Reverse Engineering";
          packages = with pkgs; [
            binwalk
            teehee
            ghidra
            radare2
            cutter
          ];
        };

        hardware-hacking = pkgs.mkShell {
          name = "Hardware Hacking";
          packages = with pkgs; [
            sigrok-cli
            sigrok-firmware-fx2lafw
            pulseview
            picotool
          ];
        };

        rust = pkgs.mkShell {
          name = "Rust dev shell";
          packages = with pkgs; [
            rustc
            rust-analyzer
            cargo
          ];
        };

        go = pkgs.mkShell {
          name = "Go dev shell";
          packages = with pkgs; [
            go
            buf
          ];
        };

        python = pkgs.mkShell {
          name = "Python dev shell";
          packages = with pkgs; [
            uv
            ruff
            pyright
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
