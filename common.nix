# ==============================================================================
# HOME/COMMON.NIX — Shared home-manager configuration
# ==============================================================================
# Packages and settings that apply on any machine.
# Platform-specific stuff goes in youruser.nix.
# ==============================================================================
{ config, pkgs, ... }:

{
  # ============================================================================
  # PACKAGES
  # ============================================================================

  home.packages = with pkgs; [
    # --------------------------------------------------------------------------
    # System Utilities
    # --------------------------------------------------------------------------
    bat            # cat with syntax highlighting
    eza            # modern ls
    fd             # modern find
    htop           # process viewer
    neofetch       # system info
    ripgrep        # fast grep
    tree           # directory tree
    gum            # pretty shell scripting

    # --------------------------------------------------------------------------
    # Terminal & Shell
    # --------------------------------------------------------------------------
    alacritty      # GPU-accelerated terminal
    starship       # cross-shell prompt
    tmux           # terminal multiplexer

    # --------------------------------------------------------------------------
    # Fonts
    # --------------------------------------------------------------------------
    nerd-fonts.fira-code
  ];

  # ============================================================================
  # CONFIG FILE SYMLINKS
  # ============================================================================

  home.file = {
    ".config/alacritty".source = config.lib.file.mkOutOfStoreSymlink
      "${config.home.homeDirectory}/Settings/config/common/alacritty";

    ".config/starship".source = config.lib.file.mkOutOfStoreSymlink
      "${config.home.homeDirectory}/Settings/config/common/starship";

    ".config/nvim".source = config.lib.file.mkOutOfStoreSymlink
      "${config.home.homeDirectory}/Settings/config/common/nvim";
  };

  # ============================================================================
  # PROGRAMS
  # ============================================================================

  programs.btop.enable = true;
  programs.fzf.enable = true;

  # ----------------------------------------------------------------------------
  # Zsh
  # ----------------------------------------------------------------------------
  programs.zsh = {
    enable = true;

    initContent = ''
      export PATH=$HOME/Settings/scripts:$PATH
      export EDITOR=nvim
      export VISUAL=nvim

      # Eza aliases
      alias ls='eza --icons'
      alias ll='eza -la --icons'
      alias cat='bat'

      # Case-insensitive completion
      zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

      # Git workflow shortcuts
      gpdev() {
        git add -A && git commit -m "$1" && git push origin dev
      }
      gpmain() {
        git add -A && git commit -m "$1" && git push origin main
      }
      alias gs='git status'
    '';
  };

  # ----------------------------------------------------------------------------
  # Git
  # ----------------------------------------------------------------------------
  programs.git = {
    enable = true;

    settings.user.name  = "Your Name";       # CHANGE ME
    settings.user.email = "your@email.com";  # CHANGE ME

    settings.aliases = {
      st     = "status";
      co     = "checkout";
      br     = "branch";
      cm     = "commit -m";
      last   = "log -1 HEAD";
      unstage = "reset HEAD --";
      amend  = "commit --amend --no-edit";
    };
  };

  # ----------------------------------------------------------------------------
  # Neovim (LazyVim — config lives in config/common/nvim)
  # ----------------------------------------------------------------------------
  programs.neovim = {
    enable = true;
    defaultEditor = true;

    extraPackages = with pkgs; [
      ripgrep
      fd
      gcc
      gnumake
      unzip

      # LSPs & formatters — add/remove to taste
      lua-language-server
      stylua
      nixd
    ];
  };

  # ----------------------------------------------------------------------------
  # Starship prompt
  # ----------------------------------------------------------------------------
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
  };

  # ----------------------------------------------------------------------------
  # SSH
  # ----------------------------------------------------------------------------
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    matchBlocks."*".addKeysToAgent = "yes";
  };

  services.ssh-agent.enable = true;
}
