{
  description = "Joshua's NixOS Config Platform";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }:
  let
    system = "x86_64-linux";
  in
  {
    nixosConfigurations.EliteDesk = nixpkgs.lib.nixosSystem {
      inherit system;

      modules = [
        ./system/hosts/EliteDesk/configuration.nix
        
        # Home Manager as NixOS module
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.juso = import ./home/juso.nix;
        }
      ];
    };
  };
}
