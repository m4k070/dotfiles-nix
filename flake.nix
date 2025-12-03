{
  description = "My Nix flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs: {
    nixosConfigurations = {
      myNixOS = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
	    ./nixos/configuration.nix
	    home-manager.nixosModules.default
	    {
	      home-manager = {
	        useGlobalPkgs = true;
	        useUserPackages = true;
	        users.makoto = ./home/home.nix;
	      };
	    }
	  ];
        };
      };
    homeConfigurations = {
      myHome = home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs {
          system = "x86_64-linux";
	  config.allowUnfree = true;
	};
        extraSpecialArgs = {
	  inherit inputs;
        };
        modules = [./home/home.nix];
      };
    };
  };
}
