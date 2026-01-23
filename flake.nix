{
  description = "My Nix flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixgl = {
      url = "github:nix-community/nixgl";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-hazkey.url = "github:aster-void/nix-hazkey";
  };

  outputs = { self, nixpkgs, home-manager, nixgl, noctalia, nix-hazkey, ... }@inputs:
  let
    extraSpecialArgs = { inherit nixgl noctalia nix-hazkey; };
  in {
    nixosConfigurations = {
      sirius = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/sirius/configuration.nix
            home-manager.nixosModules.default
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                users.makoto = ./home/work.nix;
                backupFileExtension = ".backup";
                inherit extraSpecialArgs;
              };
            }
        ];
      };
      vega =  nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/vega/configuration.nix
            home-manager.nixosModules.default
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                users.makoto = ./home/home.nix;
                backupFileExtension = ".backup";
                inherit extraSpecialArgs;
              };
            }
        ];
      };
    };
    homeConfigurations = {
      work = home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs {
          system = "x86_64-linux";
          config.allowUnfree = true;
        };
        inherit extraSpecialArgs;
        modules = [./home/work.nix];
      };
      home = home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs {
          system = "x86_64-linux";
          config.allowUnfree = true;
        };
        inherit extraSpecialArgs;
        modules = [./home/home.nix];
      };
    };
  };
}
