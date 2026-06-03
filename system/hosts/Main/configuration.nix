# ==============================================================================
# SYSTEM/HOSTS/YOURHOSTNAME/CONFIGURATION.NIX
# ==============================================================================
# Main system configuration. Rename the containing folder to your hostname.
# Replace all CHANGE ME markers before building.
# ==============================================================================

{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix   # copy from /etc/nixos/ after install
  ];

  # ============================================================================
  # BOOT
  # ============================================================================

  boot = {
    loader.systemd-boot.enable      = true;
    loader.efi.canTouchEfiVariables = true;
    kernelPackages = pkgs.linuxPackages_latest;
  };

  # ============================================================================
  # NIX
  # ============================================================================

  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    auto-optimise-store   = true;
    keep-outputs          = true;
    keep-derivations      = true;
  };

  nixpkgs.config.allowUnfree = true;

  # ============================================================================
  # NETWORKING — CHANGE ME
  # ============================================================================

  networking = {
    hostName = "YourHostname";     # CHANGE ME
    networkmanager.enable = true;
    firewall.enable = true;        # set false only if you know what you're doing
  };

  # ============================================================================
  # LOCALISATION — CHANGE ME
  # ============================================================================

  time.timeZone = "Europe/London"; # CHANGE ME — e.g. "America/New_York"

  i18n.defaultLocale = "en_GB.UTF-8"; # CHANGE ME if needed

  console.keyMap = "uk"; # CHANGE ME — "us", "de", etc.

  services.xserver.xkb = {
    layout  = "gb"; # CHANGE ME
    variant = "";
  };

  # ============================================================================
  # DESKTOP ENVIRONMENT
  # ==============================================================================
  # Uncomment ONE display manager + DE block below, or bring your own.
  # ==============================================================================

  # --- GNOME ------------------------------------------------------------------
  # services.xserver.enable = true;
  # services.xserver.desktopManager.gnome.enable = true;
  # services.displayManager.gdm.enable = true;

  # --- KDE Plasma 6 -----------------------------------------------------------
  # services.xserver.enable = true;
  # services.desktopManager.plasma6.enable = true;
  # services.displayManager.sddm = {
  #   enable = true;
  #   wayland.enable = true;
  # };

  # --- Minimal / bring your own WM (Hyprland, Niri, Sway, etc.) -------------
  # services.xserver.enable = true;
  # services.displayManager.greetd.enable = true;   # or another DM
  # programs.hyprland.enable = true;                # example

  # ============================================================================
  # SERVICES
  # ============================================================================

  services = {
    # Audio
    pipewire = {
      enable              = true;
      alsa.enable         = true;
      alsa.support32Bit   = true;
      pulse.enable        = true;
    };

    # File management helpers (useful for most DEs)
    gvfs.enable    = true;
    udisks2.enable = true;
    tumbler.enable = true;  # thumbnail service (remove if not using Thunar/Nautilus)

    # SSH
    openssh.enable = true;
  };

  # ============================================================================
  # PROGRAMS
  # ============================================================================

  programs = {
    zsh.enable   = true;
    xwayland.enable = true;   # X11 app compatibility on Wayland

    # File manager — swap for dolphin, nautilus, etc. if you prefer
    thunar = {
      enable  = true;
      plugins = with pkgs; [
        thunar-archive-plugin
        thunar-volman
      ];
    };

    # GPG
    gnupg.agent = {
      enable         = true;
      enableSSHSupport = true;
    };

    # Gaming — remove if not needed
    # steam = {
    #   enable                        = true;
    #   remotePlay.openFirewall       = true;
    #   dedicatedServer.openFirewall  = true;
    #   gamescopeSession.enable       = true;
    # };
    # gamemode.enable = true;
  };

  # ============================================================================
  # SECURITY
  # ============================================================================

  security.rtkit.enable = true;

  # ============================================================================
  # ENVIRONMENT
  # ============================================================================

  environment.sessionVariables = {
    MOZ_ENABLE_WAYLAND = "1";
    NIXOS_OZONE_WL     = "1";    # Electron apps on Wayland
    QT_QPA_PLATFORM    = "wayland";
  };

  environment.systemPackages = with pkgs; [
    git
    vim
    wget
  ];

  # ============================================================================
  # USERS — CHANGE ME
  # ============================================================================

  users.users.youruser = {     # CHANGE ME — must match home/youruser.nix
    isNormalUser  = true;
    description   = "Your Name";   # CHANGE ME
    extraGroups   = [ "networkmanager" "wheel" ];
    shell         = pkgs.zsh;
  };

  # ============================================================================
  # STATE VERSION — do not change after first install
  # ============================================================================

  system.stateVersion = "25.11";
}
