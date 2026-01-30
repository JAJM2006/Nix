{
  description = "Joshua's NixOS Configuration Platform";

  # ============================================================================
  # INPUTS
  # ============================================================================
  
  inputs = {
    # NixOS unstable channel
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    
    # Darwin (macOS) packages
    nixpkgs-darwin.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    
    # Home Manager for user environment management
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
   
    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # nix-darwin for macOS system management
    darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs-darwin";
    };
  };

  # ============================================================================
  # OUTPUTS
  # ============================================================================
  
  outputs = { self, nixpkgs, nixpkgs-darwin, home-manager, darwin, noctalia, ... }@inputs:
  let
    # System architectures
    linuxSystem = "x86_64-linux";
    darwinSystem = "aarch64-darwin";  # Apple Silicon (M1/M2/M3)
    # darwinSystem = "x86_64-darwin";  # Intel Mac (uncomment if needed)
  in
  {
    # ==========================================================================
    # NIXOS CONFIGURATIONS (Linux)
    # ==========================================================================
    
    nixosConfigurations = {
      # ------------------------------------------------------------------------
      # EliteDesk - Main Desktop Configuration
      # ------------------------------------------------------------------------
      EliteDesk = nixpkgs.lib.nixosSystem {
        system = linuxSystem;
        
        modules = [
          # System configuration
          ./system/hosts/EliteDesk/configuration.nix
          
          # Home Manager as NixOS module
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.juso = import ./home/juso.nix;
            home-manager.extraSpecialArgs = { inherit inputs; };
          }
        ];
      };
      
      # ------------------------------------------------------------------------
      # ISO - Bootable Installer with Configuration
      # ------------------------------------------------------------------------
      iso = nixpkgs.lib.nixosSystem {
        system = linuxSystem;
        modules = [ ./iso.nix ];
      };
    };
    
    # ==========================================================================
    # DARWIN CONFIGURATIONS (macOS)
    # ==========================================================================
    
    darwinConfigurations = {
      # ------------------------------------------------------------------------
      # MacBook - macOS Configuration
      # ------------------------------------------------------------------------
      MacBook = darwin.lib.darwinSystem {
        system = darwinSystem;
        
        modules = [
          # System configuration
          ./system/hosts/MacBook/configuration.nix
          
          # Home Manager as Darwin module
          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.joshuamcmanus = import ./home/juso-darwin.nix;
          }
        ];
      };
    };
  };
}
