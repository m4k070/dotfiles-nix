{
  description = "My Nix flake";

  nixConfig = {
    extra-substituters = [
      "https://herdr.cachix.org"
    ];
    extra-trusted-public-keys = [
      "herdr.cachix.org-1:3nH7IStRsS0ASfdonA0DCRR2ZrSCeWitZ7Kwew0cR4I="
    ];
  };

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
    noctalia.url = "github:noctalia-dev/noctalia-shell";
    claude-code.url = "github:sadjow/claude-code-nix";
    hibiki = {
      url = "github:linuxmobile/hibiki";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    herdr = {
      url = "github:ogulcancelik/herdr";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    omp-flake = {
      url = "github:cernoh/omp-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hermes-agent.url = "github:NousResearch/hermes-agent";
  };

  outputs = { self, nixpkgs, home-manager, nixgl, noctalia, claude-code, hibiki, herdr, omp-flake, hermes-agent, ... }@inputs:
  let
    username = "makoto";
    pkgs = import nixpkgs {
      localSystem = { system = "x86_64-linux"; };
      config.allowUnfree = true;
      # katrain / katago は overlay 由来。hosts/vega/configuration.nix と揃えて
      # standalone の homeConfigurations.home でも解決できるようにする。
      overlays = [ (import ./katrain-nix/katrain-overlay.nix) ];
    };
    extraSpecialArgs = { inherit nixgl noctalia claude-code hibiki herdr omp-flake hermes-agent username; };
  in {
    nixosConfigurations = {
      MTS23001 = nixpkgs.lib.nixosSystem {
        modules = [
          ./hosts/MTS23001/configuration.nix
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
