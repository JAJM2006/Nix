# ==============================================================================
# JAJM2006's  DETERMINATE NIX SYSTEM CONFIGURATION - MacBook
# ==============================================================================
# This is the main system configuration file for macOS using nix-darwin.
# Documentation: https://github.com/LnL7/nix-darwin
# ==============================================================================
{ config, pkgs, lib, ... }:

{
  # ============================================================================
  # NIX CONFIGURATION
  # ============================================================================
  nix.enable = false;

  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
  };
  
  # CHANGED: Use nix.optimise.automatic instead
  # nix.optimise.automatic = true;

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
  
#  homebrew = {
#    enable = true;
#    
#    onActivation = {
#      autoUpdate = true;
#      cleanup = "zap";
#      upgrade = true;
#    };
#    
#    brews = [ ];
#    casks = [ ];
#  };

  # ============================================================================
  # MACOS SYSTEM SETTINGS
  # ============================================================================
  
  system = {
    defaults = {
      dock = {
        autohide = true;
        orientation = "bottom";
        show-recents = false;
        tilesize = 64;  # Size set to ~5/10 (range: 16-128, default is 64)
        
        # Optional: Enable magnification on hover for easier clicking
        magnification = true;
        largesize = 80;  # Size when magnified (if magnification is enabled)
        
        # Minimize windows using scale effect (looks nicer than genie)
        mineffect = "scale";
        
        # Show indicator lights for open applications
        show-process-indicators = true;
        
        # Don't automatically rearrange spaces based on most recent use
        mru-spaces = false;
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
        
        # Natural scrolling
        "com.apple.swipescrolldirection" = true;
      };
      
      trackpad = {
        # Tap to click
        Clicking = true;
        
        # Three finger drag (you had this disabled)
        TrackpadThreeFingerDrag = false;
        
        # Secondary click (right-click with two fingers)
        TrackpadRightClick = true;
      };
      
      # Additional trackpad settings via CustomUserPreferences
      CustomUserPreferences = {
        "com.apple.AppleMultitouchTrackpad" = {
          # Tracking speed (range: 0.0 to 3.0, your "3 out of 10" ≈ 0.6875)
          # Adjust between 0.0 (slow) and 3.0 (fast)
          TrackpadScaling = 0.6875;
          
          # Force Click and haptic feedback - disabled
          ForceSuppressed = true;
          ActuateDetents = 0;
          
          # Click pressure - light (0 = light, 1 = medium, 2 = firm)
          FirstClickThreshold = 0;
          SecondClickThreshold = 0;
          
          # Gestures
          TrackpadPinch = true;              # Zoom in or out (pinch)
          TrackpadRotate = true;             # Rotate with two fingers
          TrackpadTwoFingerDoubleTapGesture = 1;  # Smart zoom
          TrackpadThreeFingerVertSwipeGesture = 2;  # Mission Control (swipe up)
          TrackpadFourFingerVertSwipeGesture = 2;   # App Exposé (swipe down)
          TrackpadFourFingerHorizSwipeGesture = 2;  # Swipe between full-screen apps
        };
        
        "com.apple.driver.AppleBluetoothMultitouch.trackpad" = {
          # Mirror settings for Bluetooth trackpad
          Clicking = true;
          TrackpadRightClick = true;
          TrackpadScaling = 0.6875;
        };
      };
    };
    
    keyboard = {
      enableKeyMapping = true;
      remapCapsLockToControl = true;
    };
    
    stateVersion = 5;
  };



	system.activationScripts.applications.text = lib.mkForce ''
	  echo "setting up /Applications/Nix Apps..." >&2
  
	  # Clean up old symlinks
	  rm -rf "/Applications/Nix Apps"
 	 mkdir -p "/Applications/Nix Apps"
  
	  # Create symlinks for all .app bundles in user profile
 	 find ${config.system.build.applications}/Applications -maxdepth 1 -name '*.app' -type l -exec sh -c '
	    src="$1"
	    app_name=$(basename "$src")
	    ln -sf "$src" "/Applications/Nix Apps/$app_name"
	  ' sh {} \;
  
	  # Also link from home-manager profile
	  if [ -d "/etc/profiles/per-user/joshuamcmanus/Applications" ]; then
	    find /etc/profiles/per-user/joshuamcmanus/Applications -maxdepth 1 -name '*.app' -type l -exec sh -c '
	      src="$1"
	      app_name=$(basename "$src")
	      ln -sf "$src" "/Applications/Nix Apps/$app_name"
	    ' sh {} \;
	  fi
	'';

  # ============================================================================
  # PROGRAMS
  # ============================================================================
  
  programs.zsh.enable = true;

  # ============================================================================
  # USER CONFIGURATION
  # ============================================================================
  
  users.users.joshuamcmanus = {
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
