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
    /home/juso/Settings/system/hosts/EliteDesk/hardware-configuration.nix
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
  # LOCALIZATION
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
  
  # X11 keymap
  services.xserver.xkb = {
    layout = "gb";
    variant = "";
  };
  
  # Console keymap
  console.keyMap = "uk";
 
  # ============================================================================
  # DISPLAY MANAGER & WINDOW MANAGER
  # ============================================================================
  
  # Greetd display manager with tuigreet
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.tuigreet}/bin/tuigreet --time --cmd ${pkgs.niri}/bin/niri-session";
      };
    };
  };
  
  # Enable niri window manager
  programs.niri.enable = true;
  programs.xwayland.enable = true;
  
  # Wayland environment variables
  environment.sessionVariables = {
    MOZ_ENABLE_WAYLAND = "1";
    QT_QPA_PLATFORM = "wayland";
    XDG_CURRENT_DESKTOP = "niri";
    XDG_SESSION_TYPE = "wayland";
    NIXOS_OZONE_WL = "1";
    
    # Force Steam to use SDL Wayland backend
    SDL_VIDEODRIVER = "wayland";
  };

  # ============================================================================
  # FILE MANAGEMENT & USB AUTOMOUNTING
  # ============================================================================
  
  # Enable USB automounting services
  services = {
    devmon.enable = true;
    gvfs.enable = true;
    tumbler.enable = true;
    udisks2.enable = true;
  };
  
  # Thunar file manager with plugins
  programs.thunar = {
    enable = true;
    plugins = with pkgs; [
      thunar-archive-plugin
      thunar-media-tags-plugin
      thunar-volman
    ];
  };

  # ============================================================================
  # AUDIO
  # ============================================================================
  
  security.rtkit.enable = true;

  services.mpd = {
    enable = true;
    user = "juso";
    musicDirectory = "/home/juso/Music";
    startWhenNeeded = false;
  
    settings = {
      audio_output = [
        {
          type = "pipewire";
          name = "PipeWire Sound Server";
        }
      ];
    };
  };

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # ============================================================================
  # GAMING
  # ============================================================================
  
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    gamescopeSession.enable = true;
  };
  
  # Enable GameMode for performance optimization
  programs.gamemode.enable = true;

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
  # SYSTEM-WIDE PROGRAMS
  # ============================================================================
  
  programs = {
    # Enable zsh system-wide
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
  # PRIVACY & SECURITY
  # ============================================================================
  
  services.tor = {
    enable = true;
    client.enable = true;
    
    # Optional: configure Tor settings
    settings = {
      # SOCKS proxy on localhost:9050
      SOCKSPort = [ 9050 ];
      
      # Control port (for tools like Nyx)
      ControlPort = [ 9051 ];
    };
  };

  # ============================================================================
  # SYSTEM PACKAGES
  # ============================================================================
  
  environment.systemPackages = with pkgs; [
    git
    niri
    vim
    wget
  ];
  
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # ============================================================================
  # SERVICES
  # ============================================================================
  
  # Enable OpenSSH daemon
  services.openssh.enable = true;

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
