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
    # Enable flakes and nix-command
    experimental-features = [ "nix-command" "flakes" ];
    
    # Store optimization
    auto-optimise-store = true;
  };

  # ============================================================================
  # SYSTEM PACKAGES
  # ============================================================================
  
  environment.systemPackages = with pkgs; [
    git
    vim
    wget
  ];

  # ============================================================================
  # HOMEBREW (Optional - for Mac-specific apps)
  # ============================================================================
  
  homebrew = {
    enable = true;
    
    # Automatically update Homebrew
    onActivation = {
      autoUpdate = true;
      cleanup = "zap";
      upgrade = true;
    };
    
    # Formulae (CLI tools)
    brews = [
      # "mas"  # Mac App Store CLI (uncomment if needed)
    ];
    
    # Casks (GUI applications)
    casks = [
      # Examples - uncomment what you want:
      # "firefox"
      # "visual-studio-code"
      # "rectangle"  # Window manager
      # "alacritty"  # Terminal
    ];
    
    # Mac App Store apps (requires mas)
    # masApps = {
    #   "Xcode" = 497799835;
    # };
  };

  # ============================================================================
  # MACOS SYSTEM SETTINGS
  # ============================================================================
  
  system = {
    # macOS defaults
    defaults = {
      # Dock settings
      dock = {
        autohide = true;
        orientation = "bottom";
        show-recents = false;
        tilesize = 48;
      };
      
      # Finder settings
      finder = {
        AppleShowAllExtensions = true;
        FXEnableExtensionChangeWarning = false;
        QuitMenuItem = true;
        _FXShowPosixPathInTitle = true;
      };
      
      # Global macOS settings
      NSGlobalDomain = {
        AppleInterfaceStyle = "Dark";  # Dark mode
        AppleKeyboardUIMode = 3;       # Full keyboard access
        ApplePressAndHoldEnabled = false;  # Key repeat instead of accents
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
      
      # Trackpad settings
      trackpad = {
        Clicking = true;  # Tap to click
        TrackpadThreeFingerDrag = true;
      };
    };
    
    # Keyboard settings
    keyboard = {
      enableKeyMapping = true;
      remapCapsLockToControl = true;
    };
    
    # System state version
    stateVersion = 5;
  };

  # ============================================================================
  # SERVICES
  # ============================================================================
  
  services = {
    # Nix daemon
    nix-daemon.enable = true;
  };

  # ============================================================================
  # PROGRAMS
  # ============================================================================
  
  programs = {
    # Enable zsh system-wide
    zsh.enable = true;
  };

  # ============================================================================
  # USER CONFIGURATION
  # ============================================================================
  
  users.users.juso = {
    name = "juso";
    home = "/Users/juso";
    shell = pkgs.zsh;
  };

  # ============================================================================
  # FONTS
  # ============================================================================
  
  fonts = {
    packages = with pkgs; [
      nerd-fonts.fira-code
    ];
  };
}
