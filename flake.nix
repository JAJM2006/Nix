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

        # Home Manager integration
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;

          # User-specific settings
          home-manager.users.juso = import (builtins.path { path = ./home/juso.nix; }) { pkgs = nixpkgs.legacyPackages.${system}; };
        }
      ];
    };
  };
}

