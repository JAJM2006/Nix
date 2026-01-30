# ==============================================================================
# JAJM2006's  NIX-DARWIN SYSTEM CONFIGURATION - MacBook
# ==============================================================================
# This is the main system configuration file for macOS using nix-darwin.
# Documentation: https://github.com/LnL7/nix-darwin
# ==============================================================================

{ config, pkgs, ... }:

{
  # ============================================================================
  # NIX CONFIGURATION
  # ============================================================================
  
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
  };
  
  # CHANGED: Use nix.optimise.automatic instead
  nix.optimise.automatic = true;

  # ============================================================================
  # SYSTEM PACKAGES
  # ============================================================================
  
  environment.systemPackages = with pkgs; [
    git
    vim
    wget
  ];

  # ============================================================================
  # PRIMARY USER
  # ============================================================================
  
  system.primaryUser = "joshuamcmanus";  # CHANGED from juso

  # ============================================================================
  # HOMEBREW
  # ============================================================================
  
  homebrew = {
    enable = true;
    
    onActivation = {
      autoUpdate = true;
      cleanup = "zap";
      upgrade = true;
    };
    
    brews = [ ];
    casks = [ ];
  };

  # ============================================================================
  # MACOS SYSTEM SETTINGS
  # ============================================================================
  
  system = {
    defaults = {
      dock = {
        autohide = true;
        orientation = "bottom";
        show-recents = false;
        tilesize = 48;
      };
      
      finder = {
        AppleShowAllExtensions = true;
        FXEnableExtensionChangeWarning = false;
        QuitMenuItem = true;
        _FXShowPosixPathInTitle = true;
      };
      
      NSGlobalDomain = {
        AppleInterfaceStyle = "Dark";
        AppleKeyboardUIMode = 3;
        ApplePressAndHoldEnabled = false;
        InitialKeyRepeat = 15;
        KeyRepeat = 2;
        NSAutomaticCapitalizationEnabled = false;
        NSAutomaticDashSubstitutionEnabled = false;
        NSAutomaticPeriodSubstitutionEnabled = false;
        NSAutomaticQuoteSubstitutionEnabled = false;
        NSAutomaticSpellingCorrectionEnabled = false;
        NSNavPanelExpandedStateForSaveMode = true;
        NSTableViewDefaultSizeMode = 2;
      };
      
      trackpad = {
        Clicking = true;
        TrackpadThreeFingerDrag = true;
      };
    };
    
    keyboard = {
      enableKeyMapping = true;
      remapCapsLockToControl = true;
    };
    
    stateVersion = 5;
  };

  # ============================================================================
  # PROGRAMS
  # ============================================================================
  
  programs.zsh.enable = true;

  # ============================================================================
  # USER CONFIGURATION
  # ============================================================================
  
  users.users.joshuamcmanus = {  # CHANGED from juso
    name = "joshuamcmanus";
    home = "/Users/joshuamcmanus";
    shell = pkgs.zsh;
  };

  # ============================================================================
  # FONTS
  # ============================================================================
  
  fonts.packages = with pkgs; [
    nerd-fonts.fira-code
  ];
}
