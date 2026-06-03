# ==============================================================================
# HOME/YOURUSER.NIX — NixOS-specific home-manager config
# ==============================================================================
# Rename this file to match your username (e.g. home/alice.nix).
# Update flake.nix to point at the new filename.
# Common settings live in common.nix — add NixOS-only things here.
# ==============================================================================
{ config, pkgs, inputs, ... }:

{
  imports = [ ./common.nix ];

  # ============================================================================
  # USER INFO — CHANGE THESE
  # ============================================================================

  home.username    = "youruser";           # your Linux username
  home.homeDirectory = "/home/youruser";   # update to match
  home.stateVersion  = "25.11";

  # ============================================================================
  # NIXOS-SPECIFIC PACKAGES
  # ============================================================================

  home.packages = with pkgs; [
    # --------------------------------------------------------------------------
    # Basics
    # --------------------------------------------------------------------------
    brightnessctl   # backlight control
    firefox         # browser
    playerctl       # media key support

    # --------------------------------------------------------------------------
    # Desktop utilities — uncomment what you need
    # --------------------------------------------------------------------------
    # cliphist        # clipboard history (Wayland)
    # grim            # screenshot (Wayland)
    # slurp           # region select for screenshots
    # swww            # wallpaper daemon (Wayland)
    # wl-clipboard    # clipboard CLI (Wayland)
    # dunst           # notification daemon (standalone WMs)
    # rofi            # app launcher (standalone WMs)

    # --------------------------------------------------------------------------
    # Audio
    # --------------------------------------------------------------------------
    pavucontrol     # PulseAudio/PipeWire GUI volume control
    # ncmpcpp         # TUI MPD client (uncomment if you use MPD)
    # mpc             # MPD CLI (uncomment if you use MPD)

    # --------------------------------------------------------------------------
    # Themes — swap these out to your taste
    # --------------------------------------------------------------------------
    bibata-cursors
    papirus-icon-theme
  ];

  # ============================================================================
  # MPD (Music Player Daemon) — uncomment if you want it
  # ============================================================================

  # services.mpd = {
  #   enable = true;
  #   musicDirectory = "${config.home.homeDirectory}/Music";
  #   network.listenAddress = "127.0.0.1";
  #   network.port = 6600;
  #   extraConfig = ''
  #     audio_output {
  #       type "pipewire"
  #       name "PipeWire Sound Server"
  #     }
  #     auto_update "yes"
  #     restore_paused "yes"
  #   '';
  # };

  # ============================================================================
  # ADDITIONAL ZSH CONFIG (NixOS-specific)
  # ============================================================================

  programs.zsh.initContent = ''
    # Wayland wallpaper helpers — uncomment if you use swww
    # wall() { swww img "$1" --transition-type wipe --transition-angle 30; }
    # wallrandom() { swww img "$(find ~/Pictures/Wallpapers -type f | shuf -n 1)" --transition-type random; }
  '';
}
