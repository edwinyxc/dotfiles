{
  description = "Laptop farm";

  # TODO extract the version string e.g. `21.11` or `21.05`
  inputs = {
  	# flake/inputs.nixpkgs
	stable.url = "github:nixos/nixpkgs/nixos-21.11";
	unstable.url = "github:nixos/nixpkgs/nixos-unstable-small";
	master.url = "github:nixos/nixpkgs/master";
	fallback.url = "github:nixos/nixpkgs/nixos-unstable";

	nixpkgs.follows = "stable";

	# flake/inputs.core
	home-manager.url = "github:nix-community/home-manager/release-21.11";
	home-manager.inputs.nixpkgs.follows = "nixpkgs";
	#flake-utils-plus.url = "github:gytis-ivaskevicius/flake-utils-plus";

	# flake/inputs.packages
	#nur.url = "github:nix-community/NUR";
	fenix = {
		url = "github:nix-community/fenix";
		inputs.nixpkgs.follows = "nixpkgs";
	};
	neovim.url = "github:nix-community/neovim-nightly-overlay";
  };

  outputs = inputs@{ self,  ... }:
  let 
  	system = "x86_64-linux";

	pkgs   = import nixpkgs {
  	  inherit system;
  	  config = { allowUnfree = true; };
	};

	#overlays = {};

	lib = nixpkgs.lib;

  in {

    nixosConfigurations = {
      "farm-nixos" = lib.nixosSystem {
         inherit system;

	 modules = [
 	   ./nixos/configuration.nix
 	   ./nixos/hardware-configuration.nix
	 ];
      };
    };

  };
}
