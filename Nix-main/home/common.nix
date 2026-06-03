# ==============================================================================
# JAJM2006's SHARED HOME MANAGER CONFIGURATION
# ==============================================================================
# Common configuration shared between NixOS (juso.nix) and macOS (darwin.nix)
# This extracts all cross-platform packages and settings.
# ==============================================================================
{ config, pkgs, ... }:

{
  # ============================================================================
  # SHARED PACKAGES
  # ============================================================================
  
  home.packages = with pkgs; [
    # --------------------------------------------------------------------------
    # System Utilities (Cross-platform)
    # --------------------------------------------------------------------------
    bat                    # Cat clone with syntax highlighting
    direnv                 # Directory-specific environments
    eza                    # Modern ls replacement
    fd                     # Modern find replacement
    htop                   # Interactive process viewer
    neofetch               # System information tool
    ripgrep                # Fast grep alternative
    tree                   # Directory tree viewer
    gum                    # Shell scripting
    
    # --------------------------------------------------------------------------
    # Terminal & Shell
    # --------------------------------------------------------------------------
    alacritty              # GPU-accelerated terminal emulator
    starship               # Cross-shell prompt
    tmux                   # Terminal multiplexer
    
    # --------------------------------------------------------------------------
    # Media
    # --------------------------------------------------------------------------
    mpc                   # Console for music player
    
    # --------------------------------------------------------------------------
    # Fonts
    # --------------------------------------------------------------------------
    nerd-fonts.fira-code   # Nerd Fonts patched FiraCode
  ];

  # ============================================================================
  # SHARED CONFIGURATION FILES
  # ============================================================================
  
  home.file = {
    # Cross-platform configs
    ".config/alacritty".source = config.lib.file.mkOutOfStoreSymlink 
      "${config.home.homeDirectory}/Settings/config/common/alacritty";
    
    ".config/starship".source = config.lib.file.mkOutOfStoreSymlink 
      "${config.home.homeDirectory}/Settings/config/common/starship";

    ".config/nvim".source = config.lib.file.mkOutOfStoreSymlink 
      "${config.home.homeDirectory}/Settings/config/common/nvim";
  };

  # ============================================================================
  # SHARED PROGRAMS
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
  # Shell Configuration (Common parts)
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
    
    settings.user.name = "Geordie Mac";
    settings.user.email = "Joshua.McManus2006@gmail.com";
    
    settings.aliases = {
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

  # ----------------------------------------------------------------------------
  # Neovim (shared LSPs and tools)
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

# ============================================================================
# END OF HOME/COMMON.NIX
# ============================================================================
}
