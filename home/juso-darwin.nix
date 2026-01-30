{ config, pkgs, ... }:

{
  # ============================================================================
  # USER INFORMATION
  # ============================================================================
  
  home.username = "juso";
  home.homeDirectory = "/Users/juso";
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
  # Starship Prompt
  # ----------------------------------------------------------------------------
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
  };
}
