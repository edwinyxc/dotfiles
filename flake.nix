{
  description = "Edwin's nixos flake";

  nixConfig = {
    experimental-features = ["nix-command" "flakes"];
  };

  inputs = {

    # Offical NixOS pkg source
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";

    # NixOS hardware 
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    #home-manager
    home-manager = {
        url = "github:nix-community/home-manager/release-23.11";
        
        # keep home-manager consistent with the current flake on `inputs.nixpkgs`
        inputs.nixpkgs.follows = "nixpkgs";
    };

  };

  outputs = {self, nixpkgs, home-manager, ...}@inputs: {

      nixosConfigurations = {

          "FW-i11" = nixpkgs.lib.nixosSystem {
              system = "x86_64-linux";

              specialArgs = inputs;
              modules = [
                  ./hosts/FW-i11

                  #framework hardware upstream tweaks
                  inputs.nixos-hardware.nixosModules.framework-11th-gen-intel

                  #home
                  home-manager.nixosModules.home-manager
                  {
                    home-manager.useGlobalPkgs = true;
                    home-manager.useUserPackages = true;
                    home-manager.extraSpecialArgs = inputs;
                    home-manager.users.ed = import ./home ;
                  }
              ];
          };
      };
  };
}
