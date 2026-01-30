{
  description = "Joshua's NixOS Configuration Platform";

  # ============================================================================
  # INPUTS
  # ============================================================================
  
  inputs = {
    # NixOS unstable channel
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    
    # Home Manager for user environment management
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  # ============================================================================
  # OUTPUTS
  # ============================================================================
  
  outputs = { self, nixpkgs, home-manager, ... }:
  let
    system = "x86_64-linux";
  in
  {
     # ==========================================================================
     # NIXOS CONFIGURATIONS
     # ==========================================================================
    
    nixosConfigurations = {
       # ------------------------------------------------------------------------
       # EliteDesk - Main Desktop Configuration
       # ------------------------------------------------------------------------
      EliteDesk = nixpkgs.lib.nixosSystem {
        inherit system;
        
        modules = [
          # System configuration
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
      
       # ------------------------------------------------------------------------
       # ISO - Bootable Installer with Configuration
       # ------------------------------------------------------------------------
       iso = nixpkgs.lib.nixosSystem {
         inherit system;
         modules = [ ./iso.nix ];
      };
    };
  };
}
