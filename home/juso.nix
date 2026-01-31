# ==============================================================================
# JAJM2006's NIXOS HOME MANAGER CONFIGURATION - EliteDesk
# ==============================================================================
# NixOS-specific configuration. Common settings are in common.nix
# Documentation: https://github.com/nix-community/home-manager
# ==============================================================================
{ config, pkgs, inputs, ... }:

{
  # ============================================================================
  # IMPORTS
  # ============================================================================
  
  imports = [
    ./common.nix
    inputs.noctalia.homeModules.default
  ];

  # ============================================================================
  # USER INFORMATION
  # ============================================================================
  
  home.username = "juso";
  home.homeDirectory = "/home/juso";
  home.stateVersion = "25.11";

  # ============================================================================
  # NIXOS-SPECIFIC PACKAGES
  # ============================================================================
  
  home.packages = with pkgs; [
    # --------------------------------------------------------------------------
    # Linux/Wayland-specific
    # --------------------------------------------------------------------------
    brightnessctl          # Brightness control
    firefox                # Web browser
    nix-output-monitor     # Output monitoring
    playerctl              # Media player controller
    
    # --------------------------------------------------------------------------
    # Desktop Environment (Wayland)
    # --------------------------------------------------------------------------
    cliphist               # Clipboard history manager
    dunst                  # Notification daemon
    grim                   # Screenshot utility
    mangohud               # Gaming HUD
    rofi                   # Application launcher
    slurp                  # Region selector for screenshots
    swww                   # Wallpaper daemon (wayland)
    tor-browser            # The Onion Router
    waybar                 # Status bar
    wl-clipboard           # Wayland clipboard utilities
    
    # --------------------------------------------------------------------------
    # File Management
    # --------------------------------------------------------------------------
    file-roller            # Archive manager
    pavucontrol            # PulseAudio volume control
    
    # --------------------------------------------------------------------------
    # Themes
    # --------------------------------------------------------------------------
    bibata-cursors         # Cursor theme
    papirus-icon-theme     # Icon theme
  ];

  # ============================================================================
  # NIXOS-SPECIFIC CONFIGURATION FILES
  # ============================================================================
  
  home.file = {
    # Linux-specific window manager and tools
    ".config/dunst".source = config.lib.file.mkOutOfStoreSymlink 
      "${config.home.homeDirectory}/Settings/config/nixos/dunst";
    
    ".config/niri".source = config.lib.file.mkOutOfStoreSymlink 
      "${config.home.homeDirectory}/Settings/config/nixos/niri";
    
    ".config/rofi".source = config.lib.file.mkOutOfStoreSymlink 
      "${config.home.homeDirectory}/Settings/config/nixos/rofi";
    
    ".config/waybar".source = config.lib.file.mkOutOfStoreSymlink 
     "${config.home.homeDirectory}/Settings/config/nixos/waybar";

    # Desktop entry for Steam with Gamescope
    ".local/share/applications/steam-gamescope.desktop".text = ''
      [Desktop Entry]
      Name=Steam (Gamescope)
      Comment=Application for managing and playing games on Steam
      Exec=gamescope -- steam %U
      Icon=steam
      Terminal=false
      Type=Application
      Categories=Network;FileTransfer;Game;
      MimeType=x-scheme-handler/steam;x-scheme-handler/steamlink;
      PrefersNonDefaultGPU=true
      X-KDE-RunOnDiscreteGpu=true
    '';
  };

  # ============================================================================
  # NIXOS-SPECIFIC PROGRAMS
  # ============================================================================
  
  # ----------------------------------------------------------------------------
  # Noctalia Shell
  # ----------------------------------------------------------------------------
  programs.noctalia-shell = {
    enable = true;
    settings = "${config.home.homeDirectory}/Settings/config/nixos/noctalia/settings.json";
  };
  
  # ----------------------------------------------------------------------------
  # ZSH 
  # ----------------------------------------------------------------------------
  programs.zsh = {
    initExtra = ''
      # Case-insensitive completion
      zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
      
      # Wallpaper functions (Wayland)
      wall() {
        swww img "$1" --transition-type wipe --transition-angle 30
      }

      wallrandom() {
        swww img "$(find ~/Pictures/Wallpapers -type f | shuf -n 1)" --transition-type random
      }
    '';
  };
  
  # ----------------------------------------------------------------------------
  # SSH Configuration
  # ----------------------------------------------------------------------------
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    matchBlocks = {
      "*" = {
        addKeysToAgent = "yes";
      };
    };
  };
  
  services.ssh-agent.enable = true;

# ============================================================================
# END OF HOME/JUSO.NIX
# ============================================================================
}
