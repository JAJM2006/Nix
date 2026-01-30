# ==============================================================================
# JAJM2006's  NIX-DARWIN HOME MANAGER CONFIGURATION - MacBook
# ==============================================================================
# This is the main system configuration file for macOS using nix-darwin.
# Documentation: https://github.com/LnL7/nix-darwin
# ============================================================================== 
{config, pkgs, ... }:

{
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
    # --------------------------------------------------------------------------
    # System Utilities
    # --------------------------------------------------------------------------
    bat                    # Cat clone with syntax highlighting
    direnv                 # Directory-specific environments
    eza                    # Modern ls replacement
    fd                     # Modern find replacement
    htop                   # Interactive process viewer
    neofetch               # System information tool
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
    neovim                 # Vim-based text editor
    
    # --------------------------------------------------------------------------
    # Media
    # --------------------------------------------------------------------------
    cmus                   # Console music player
    
    # --------------------------------------------------------------------------
    # Fonts (if not using system fonts)
    # --------------------------------------------------------------------------
    nerd-fonts.fira-code   # Nerd Fonts patched FiraCode
  ];

  # ============================================================================
  # CONFIGURATION FILES
  # ============================================================================
  
  home.file = {
    ".config/alacritty".source = config.lib.file.mkOutOfStoreSymlink 
      "${config.home.homeDirectory}/Settings/config/alacritty";
    
    ".config/starship".source = config.lib.file.mkOutOfStoreSymlink 
      "${config.home.homeDirectory}/Settings/config/starship";
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
      export PATH=$HOME/.nix-profile/bin:$PATH

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
      
      # macOS-specific aliases
      alias ls='eza --icons'
      alias ll='eza -la --icons'
      alias cat='bat'
    '';
  };
  
  # ----------------------------------------------------------------------------
  # Git Configuration
  # ----------------------------------------------------------------------------
  programs.git = {
  enable = true;
  userName = "Geordie Mac";
  userEmail = "Joshua.McManus2006@gmail.com";
  
  aliases = {
    st = "status";
    co = "checkout";
    br = "branch";
    cm = "commit -m";
    cdev = "checkout dev";
    cmain = "checkout main";
    last = "log -1 HEAD";
    unstage = "reset HEAD --";
    amend = "commit --amend --no-edit";
    };
  };
  
  # ----------------------------------------------------------------------------
  # Starship Prompt
  # ----------------------------------------------------------------------------
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
  };
}
