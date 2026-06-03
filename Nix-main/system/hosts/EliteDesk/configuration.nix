# ==============================================================================
# JAJM2006's NIXOS SYSTEM CONFIGURATION - EliteDesk
# ==============================================================================
# This is the main system configuration file for NixOS.
# Help is available in the configuration.nix(5) man page and NixOS manual.
# ==============================================================================

{ config, pkgs, ... }:

{
  # ============================================================================
  # IMPORTS
  # ============================================================================
  
  imports = [
    ./hardware-configuration.nix
  ];

  # ============================================================================
  # BOOT CONFIGURATION
  # ============================================================================
  
  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    
    # Use latest kernel
    kernelPackages = pkgs.linuxPackages_latest;
  };

  # ============================================================================
  # NIX CONFIGURATION
  # ============================================================================
  
  nix.settings = {
    # Enable flakes and nix-command
    experimental-features = [ "nix-command" "flakes" ];
    
    # Logging
    log-lines = 50;
    
    # Store optimization
    auto-optimise-store = true;
    keep-outputs = true;
    keep-derivations = true;
  };

  # ============================================================================
  # NETWORKING
  # ============================================================================
  
  networking = {
    hostName = "EliteDesk";
    networkmanager.enable = true;
    firewall.enable = false;
  };

  # ============================================================================
  # LOCALISATION
  # ============================================================================
  
  # Timezone
  time.timeZone = "Europe/London";
  
  # Locale settings
  i18n = {
    defaultLocale = "en_GB.UTF-8";
    
    extraLocaleSettings = {
      LC_ADDRESS = "en_GB.UTF-8";
      LC_IDENTIFICATION = "en_GB.UTF-8";
      LC_MEASUREMENT = "en_GB.UTF-8";
      LC_MONETARY = "en_GB.UTF-8";
      LC_NAME = "en_GB.UTF-8";
      LC_NUMERIC = "en_GB.UTF-8";
      LC_PAPER = "en_GB.UTF-8";
      LC_TELEPHONE = "en_GB.UTF-8";
      LC_TIME = "en_GB.UTF-8";
    };
  };

  # ============================================================================
  # INPUT CONFIGURATION
  # ============================================================================

  # Console keymap
  console.keyMap = "uk";

  # ============================================================================
  # SERVICES
  # ============================================================================
  
  services = {
    # --------------------------------------------------------------------------
    # Display Manager & Desktop Environment
    # --------------------------------------------------------------------------
    
    # SDDM Display Manager
    displayManager.sddm = {
      enable = true;
      wayland.enable = true;
      theme = "breeze";
    };

    # KDE Plasma Desktop Environment
    desktopManager.plasma6.enable = true;

    # X Server Configuration
    xserver = {
      enable = true;
      xkb = {
        layout = "gb";
        variant = "";
      };
    };
    
    # --------------------------------------------------------------------------
    # File Management & USB Automounting
    # --------------------------------------------------------------------------
    
    devmon.enable = true;
    gvfs.enable = true;
    tumbler.enable = true;
    udisks2.enable = true;
    
    # --------------------------------------------------------------------------
    # Audio
    # --------------------------------------------------------------------------

    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };

    # --------------------------------------------------------------------------
    # Privacy & Security
    # --------------------------------------------------------------------------
    
    tor = {
      enable = true;
      client.enable = true;
      
      settings = {
        # SOCKS proxy on localhost:9050
        SOCKSPort = [ 9050 ];
        
        # Control port (for tools like Nyx)
        ControlPort = [ 9051 ];
      };
    };
    
    # --------------------------------------------------------------------------
    # SSH
    # --------------------------------------------------------------------------
    
    openssh.enable = true;
  };

  # ============================================================================
  # SECURITY
  # ============================================================================
  
  security.rtkit.enable = true;

  # ============================================================================
  # PROGRAMS
  # ============================================================================
  
  programs = {
    # --------------------------------------------------------------------------
    # Window Managers & Compositors
    # --------------------------------------------------------------------------
    
    # Niri Wayland Compositor
    niri.enable = true;
    
    # XWayland support
    xwayland.enable = true;
    
    # --------------------------------------------------------------------------
    # File Manager
    # --------------------------------------------------------------------------
    
    # Thunar file manager with plugins
    thunar = {
      enable = true;
      plugins = with pkgs; [
        thunar-archive-plugin
        thunar-media-tags-plugin
        thunar-volman
      ];
    };
    
    # --------------------------------------------------------------------------
    # Gaming
    # --------------------------------------------------------------------------
    
    # Steam
    steam = {
      enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
      gamescopeSession.enable = true;
    };
    
    # GameMode for performance optimization
    gamemode.enable = true;
    
    # --------------------------------------------------------------------------
    # Shell & Utilities
    # --------------------------------------------------------------------------
    
    # Zsh shell
    zsh.enable = true;
    
    # Network diagnostics
    mtr.enable = true;
    
    # GPG agent
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
  };

  # ============================================================================
  # ENVIRONMENT
  # ============================================================================
  
  # Wayland environment variables (session-agnostic)
  environment.sessionVariables = {
    MOZ_ENABLE_WAYLAND = "1";
    QT_QPA_PLATFORM = "wayland";
    # XDG_CURRENT_DESKTOP removed - each session sets its own
    NIXOS_OZONE_WL = "1";
    SDL_VIDEODRIVER = "wayland";
  };
  
  # System packages
  environment.systemPackages = with pkgs; [
    git
    niri
    vim
    wget
    kdePackages.sddm-kcm
  ];

  # ============================================================================
  # NIXPKGS CONFIGURATION
  # ============================================================================
  
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # ============================================================================
  # USER ACCOUNTS
  # ============================================================================
  
  users.users.juso = {
    isNormalUser = true;
    description = "Geordie Mac";
    extraGroups = [ "networkmanager" "wheel" ];
    shell = pkgs.zsh;
    packages = with pkgs; [];
  };

  # ============================================================================
  # SYSTEM VERSION
  # ============================================================================
  # DO NOT CHANGE - This value determines the NixOS release from which the
  # default settings for stateful data, like file locations and database
  # versions, were taken. It's perfectly fine and recommended to leave this
  # value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option.
  # ============================================================================
  
  system.stateVersion = "25.11";
}
