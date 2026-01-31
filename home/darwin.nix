# ==============================================================================
# JAJM2006's NIX-DARWIN HOME MANAGER CONFIGURATION - MacBook
# ==============================================================================
# macOS-specific configuration. Common settings are in common.nix
# Documentation: https://github.com/LnL7/nix-darwin
# ============================================================================== 
{ config, pkgs, ... }:

{
  # ============================================================================
  # IMPORTS
  # ============================================================================
  
  imports = [
    ./common.nix
  ];

  # ============================================================================
  # USER INFORMATION
  # ============================================================================
  
  home.username = "joshuamcmanus";
  home.homeDirectory = "/Users/joshuamcmanus";
  home.stateVersion = "24.05";

  # ============================================================================
  # PACKAGES
  # ============================================================================
  
  home.packages = with pkgs; [
    # Examples:
    # yabai                # Tiling window manager
    # skhd                 # Hotkey daemon
    # sketchybar           # Status bar
  ];

  # ============================================================================
  # CONFIGURATION FILES
  # ============================================================================
  
  home.file = {
    # Add macOS-specific config files here when needed
    # Example:
    # ".config/yabai".source = config.lib.file.mkOutOfStoreSymlink 
    #   "${config.home.homeDirectory}/Settings/config/darwin/yabai";
  };

  # ============================================================================
  # PROGRAMS
  # ============================================================================
  
  # ----------------------------------------------------------------------------
  # ZSH
  # ----------------------------------------------------------------------------
  programs.zsh = {
    initContent = ''
      # Add Nix packages to PATH (macOS-specific)
      export PATH=$HOME/.nix-profile/bin:$PATH
      
      # macOS-specific aliases
      alias ls='eza --icons'
      alias ll='eza -la --icons'
      alias cat='bat'
    '';
  };

# ============================================================================
# END OF HOME/DARWIN.NIX
# ============================================================================
}
