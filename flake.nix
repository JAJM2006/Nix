# ==============================================================================
# FLAKE.NIX
# ==============================================================================
# The entry point for your NixOS configuration.
#
# flake.lock — commit this file. It pins every dependency to an exact version
# so your system builds identically on any machine. Run "nix flake update"
# (or use the maintain script) when you want to pull in newer packages.
# ==============================================================================
{
  description = "NixOS Configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs:
  let
    system = "x86_64-linux";
  in
  {
    nixosConfigurations = {

      # ------------------------------------------------------------------------
      # YourHostname — rename this to match your machine
      # ------------------------------------------------------------------------
      YourHostname = nixpkgs.lib.nixosSystem {
        inherit system;

        modules = [
          ./system/hosts/YourHostname/configuration.nix

          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.youruser = import ./home/youruser.nix;  # rename file + this line
            home-manager.extraSpecialArgs = { inherit inputs; };
          }
        ];
      };

    };
  };
}
