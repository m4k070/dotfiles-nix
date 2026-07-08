{
  description = "My Nix flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
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
    claude-code.url = "github:sadjow/claude-code-nix";
    hibiki = {
      url = "github:linuxmobile/hibiki";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    herdr = {
      url = "github:ogulcancelik/herdr";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, nixgl, noctalia, claude-code, hibiki, herdr, ... }@inputs:
  let
    username = "makoto";
    pkgs = import nixpkgs {
      system = "x86_64-linux";
      config.allowUnfree = true;
    };
    extraSpecialArgs = { inherit nixgl noctalia claude-code hibiki herdr username; };
  in {
    nixosConfigurations = {
      sirius = nixpkgs.lib.nixosSystem {
        modules = [
          ./hosts/sirius/configuration.nix
          home-manager.nixosModules.default
          {
            home-manager = {
              users.makoto = ./home/work.nix;
              useGlobalPkgs = true;
              useUserPackages = true;
              backupFileExtension = "backup";
              inherit extraSpecialArgs;
            };
          }
        ];
      };
      vega = nixpkgs.lib.nixosSystem {
        modules = [
          ./hosts/vega/configuration.nix
          home-manager.nixosModules.default
          {
            home-manager = {
              users.makoto = ./home/home.nix;
              useGlobalPkgs = true;
              useUserPackages = true;
              backupFileExtension = "backup";
              inherit extraSpecialArgs;
            };
          }
        ];
      };
    };
    homeConfigurations = {
      work = home-manager.lib.homeManagerConfiguration {
        inherit pkgs extraSpecialArgs;
        modules = [ ./home/work.nix ];
      };
      home = home-manager.lib.homeManagerConfiguration {
        inherit pkgs extraSpecialArgs;
        modules = [ ./home/home.nix ];
      };
      work-headless = home-manager.lib.homeManagerConfiguration {
        inherit pkgs extraSpecialArgs;
        modules = [ ./home/work-headless.nix ];
      };
    };
  };
}
