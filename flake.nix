# SPDX-License-Identifier: MIT
{
  description = "Dev environment Nix Packages";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    flake-utils.url = "github:numtide/flake-utils";
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
        hardware-hacking = pkgs.mkShell {
          name = "Hardware Hacking";
          packages = with pkgs; [
            sigrok-cli
            pulse-view
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
