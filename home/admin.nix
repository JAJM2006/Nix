# ==============================================================================
# HOME/YOURUSER.NIX — NixOS-specific home-manager config
# ==============================================================================
# Rename this file to match your username (e.g. home/alice.nix).
# Update flake.nix to point at the new filename.
# Common settings live in common.nix — add NixOS-only things here.
# ==============================================================================
{ config, pkgs, lib, inputs, ... }:

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
    brightnessctl   # backlight control (laptop screen brightness keys)
    firefox         # browser
    playerctl       # media key support (play/pause/next on keyboard)

    # --------------------------------------------------------------------------
    # Desktop utilities — uncomment what you need
    # --------------------------------------------------------------------------
    # cliphist        # clipboard history — remembers everything you copy (Wayland)
    # grim            # screenshot tool (Wayland)
    # slurp           # draw a region on screen to capture (used with grim)
    # swww            # wallpaper daemon — set and animate wallpapers (Wayland)
    # wl-clipboard    # copy/paste from the terminal (Wayland)
    # dunst           # notification popups (needed if you use a standalone WM)
    # rofi            # app launcher — like Spotlight but for Linux

    # --------------------------------------------------------------------------
    # Audio
    # --------------------------------------------------------------------------
    pavucontrol     # GUI volume mixer for PipeWire/PulseAudio
    # ncmpcpp         # TUI music player (terminal-based, works with MPD)
    # mpc             # CLI to control MPD from scripts/keybinds

    # --------------------------------------------------------------------------
    # Themes — swap these out to your taste
    # --------------------------------------------------------------------------
    bibata-cursors      # clean cursor theme
    papirus-icon-theme  # icon set used by most DEs and file managers
  ];

  # ============================================================================
  # MPD (Music Player Daemon) — uncomment if you want it
  # ============================================================================
  # MPD is a background music player you control via keyboard shortcuts or a
  # TUI client (ncmpcpp above). Skip this if you just want to use a normal
  # music app like Spotify or Rhythmbox.

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
  # lib.mkAfter ensures this is appended AFTER the shared config in common.nix
  # rather than conflicting with it.

  programs.zsh.initContent = lib.mkAfter ''
    # Wayland wallpaper helpers — uncomment if you use swww
    # wall() { swww img "$1" --transition-type wipe --transition-angle 30; }
    # wallrandom() { swww img "$(find ~/Pictures/Wallpapers -type f | shuf -n 1)" --transition-type random; }
  '';
}
