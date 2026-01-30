# ==============================================================================
# JAJM2006's  NIXOS HOME MANAGER CONFIGURATION - EliteDesk
# ==============================================================================
# This is the main system configuration file for NixOS using nix.
# Documentation: https://github.com/nix-community/home-manager
# ==============================================================================
{ config, pkgs, ... }:

{
  # ============================================================================
  # USER INFORMATION
  # ============================================================================
  
  home.username = "juso";
  home.homeDirectory = "/home/juso";
  home.stateVersion = "25.11";

  # ============================================================================
  # PACKAGES
  # ============================================================================
  
  home.packages = with pkgs; [
    # --------------------------------------------------------------------------
    # System Utilities
    # --------------------------------------------------------------------------
    bat                    # Cat clone with syntax highlighting
    brightnessctl          # Brightness control
    direnv                 # Directory-specific environments
    eza                    # Modern ls replacement
    fd                     # Modern find replacement
    firefox                # Web browser
    gum                    # Shell scripting
    htop                   # Interactive process viewer
    neofetch               # System information tool
    nix-output-monitor     # Output monitoring
    playerctl              # Media player controller
    ripgrep                # Fast grep alternative
    tree                   # Directory tree viewer
    
    # --------------------------------------------------------------------------
    # Terminal & Shell
    # --------------------------------------------------------------------------
    alacritty              # GPU-accelerated terminal emulator
    starship               # Cross-shell prompt
    tmux                   # Terminal multiplexer
    
    # --------------------------------------------------------------------------
    # Text Editors
    # --------------------------------------------------------------------------
    # neovim               # ~ Commented out as used elsewhere ~
    
    # --------------------------------------------------------------------------
    # Media
    # --------------------------------------------------------------------------
    cmus                   # Console music player
    
    # --------------------------------------------------------------------------
    # Desktop Environment
    # --------------------------------------------------------------------------
    cliphist               # Clipboard history manager
    dunst                  # Notification daemon
    grim                   # Screenshot utility
    rofi                   # Application launcher
    slurp                  # Region selector for screenshots
    waybar                 # Status bar
    wl-clipboard           # Wayland clipboard utilities
    
    # --------------------------------------------------------------------------
    # File Management
    # --------------------------------------------------------------------------
    file-roller            # Archive manager
    pavucontrol            # PulseAudio volume control
    
    # --------------------------------------------------------------------------
    # Themes & Fonts
    # --------------------------------------------------------------------------
    bibata-cursors         # Cursor theme
    nerd-fonts.fira-code   # Nerd Fonts patched FiraCode
    papirus-icon-theme     # Icon theme
  ];

  # ============================================================================
  # CONFIGURATION FILES
  # ============================================================================
  
  home.file = {
    ".config/alacritty".source = config.lib.file.mkOutOfStoreSymlink 
      "${config.home.homeDirectory}/Settings/config/alacritty";
    
    ".config/dunst".source = config.lib.file.mkOutOfStoreSymlink 
      "${config.home.homeDirectory}/Settings/config/dunst";
    
    ".config/niri".source = config.lib.file.mkOutOfStoreSymlink 
      "${config.home.homeDirectory}/Settings/config/niri";
    
    ".config/rofi".source = config.lib.file.mkOutOfStoreSymlink 
      "${config.home.homeDirectory}/Settings/config/rofi";
    
    ".config/starship".source = config.lib.file.mkOutOfStoreSymlink 
      "${config.home.homeDirectory}/Settings/config/starship";
    
    ".config/waybar".source = config.lib.file.mkOutOfStoreSymlink 
     "${config.home.homeDirectory}/Settings/config/waybar";

    ".config/nvim".source = config.lib.file.mkOutOfStoreSymlink 
      "${config.home.homeDirectory}/Settings/config/nvim";
  };

  # ============================================================================
  # PROGRAMS - MANAGED BY HOME MANAGER
  # ============================================================================
  
  # ----------------------------------------------------------------------------
  # System Monitoring
  # ----------------------------------------------------------------------------
  programs.btop.enable = true;
  
  # ----------------------------------------------------------------------------
  # Fuzzy Finder
  # ----------------------------------------------------------------------------
  programs.fzf.enable = true;
  
  # ----------------------------------------------------------------------------
  # Shell Configuration
  # ----------------------------------------------------------------------------
  programs.zsh = {
    enable = true;
    initContent = ''
      # Path configuration
      export PATH=$HOME/Settings/scripts:$PATH
      
      # Editor configuration
      export EDITOR=nvim
      export VISUAL=nvim
      
      # Git workflow functions
      gpdev() {
        git add -A && git commit -m "$1" && git push origin dev
      }
      
      gpmain() {
        git add -A && git commit -m "$1" && git push origin main
      }
      
      # Quick status check
      alias gs='git status'
    '';
  };
  
  # ----------------------------------------------------------------------------
  # Git Configuration
  # ----------------------------------------------------------------------------
  programs.git = {
    enable = true;
    
    settings = {
      user = {
        name = "Geordie Mac";
        email = "Joshua.McManus2006@gmail.com";
      };
      
      alias = {
        # Quick operations
        st = "status";
        co = "checkout";
        br = "branch";
        cm = "commit -m";
        cdev = "checkout dev";
        cmain = "checkout main";
        
        # Advanced
        last = "log -1 HEAD";
        unstage = "reset HEAD --";
        amend = "commit --amend --no-edit";
      };
    };
  };

  # ----------------------------------------------------------------------------
  # LazyVim
  # ----------------------------------------------------------------------------
  programs.neovim = {
    enable = true;
    defaultEditor = false;

    extraPackages = with pkgs; [
      ripgrep
      fd
      gcc
      gnumake
      unzip
      
      # LSPs & Formatters
      lua-language-server
      stylua
      nixd
    ];
  };

  # ----------------------------------------------------------------------------
  # Starship Prompt
  # ----------------------------------------------------------------------------
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
  };
}
