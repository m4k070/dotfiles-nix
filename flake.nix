{
  description = "My Nix flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, home-manager, flake-utils, ... }@inputs:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
      in {
        nixosConfigurations = {
          myNixOS = nixpkgs.lib.nixosSystem {
            inherit system;
            modules = [./system/configuration.nix];
          };
        };
        legacyPackages = {
          inherit (pkgs) home-manager;
          homeConfigurations = {
            myHome = home-manager.lib.homeManagerConfiguration {
              pkgs = pkgs;
              extraSpecialArgs = {
                inherit inputs;
              };
              modules = [./home/home.nix];
            };
          };
        };
      });
}
