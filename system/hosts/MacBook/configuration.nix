# ==============================================================================
# JAJM2006's  DETERMINATE NIX SYSTEM CONFIGURATION - MacBook
# ==============================================================================
# This is the main system configuration file for macOS using nix-darwin.
# Documentation: https://github.com/LnL7/nix-darwin
# ==============================================================================
{ config, pkgs, ... }:

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
