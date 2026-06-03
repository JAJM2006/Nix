# 🪟 Window Managers — Hyprland & Niri

So you want to ditch the desktop environment and go full custom. Good choice.

This guide covers what you need to know to get **Hyprland** or **Niri** running on top of this template — without cargo-culting someone else's config you don't understand.

---

## First — what does a DE actually do?

When you use KDE or GNOME, a lot of things happen automatically that you stop noticing. When you switch to a standalone window manager, you have to wire those things up yourself. Here's what you're replacing:

| Thing | What it does | Common choices |
|---|---|---|
| **Compositor / WM** | Draws and arranges windows | Hyprland, Niri, Sway |
| **Bar** | The panel at the top/bottom | Waybar, AGS, eww |
| **Launcher** | Opens apps (like the start menu) | Rofi, Wofi, Fuzzel |
| **Notifications** | Popup alerts | Dunst, Mako |
| **Wallpaper daemon** | Sets your wallpaper | swww, swaybg |
| **Idle / lock screen** | Locks after inactivity | Hyprlock, Swaylock |
| **Clipboard manager** | Remembers copied items | cliphist + wl-clipboard |
| **Screenshot tool** | Captures the screen | grim + slurp |
| **Polkit agent** | Auth popups (sudo GUIs etc.) | polkit-kde-agent, lxqt-policykit |

You don't need all of these on day one. Start with the compositor and a launcher — you can add the rest as you notice you need them.

---

## Hyprland

Hyprland is a dynamic tiling compositor with smooth animations and a large, active community. It's the most popular choice in the NixOS ricing world, and the ecosystem around it is mature.

- [Hyprland Wiki](https://wiki.hyprland.org/) — start here, it's excellent
- [Hyprland NixOS page](https://wiki.hyprland.org/Nix/Hyprland-on-NixOS/)

### system/hosts/YourHostname/configuration.nix

Add this to your system config:

```nix
# Hyprland
programs.hyprland = {
  enable = true;
  xwayland.enable = true;   # X11 app compatibility
};

# Needed for screen sharing, file pickers, etc.
xdg.portal = {
  enable = true;
  extraPortals = [ pkgs.xdg-desktop-portal-hyprland ];
};
```

### home/youruser.nix

Add to your `home.packages`:

```nix
home.packages = with pkgs; [
  # --- Hyprland ecosystem ---------------------------------------------------
  # Pick one from each category, or leave them all commented until you decide

  # Bar
  waybar           # the most popular, highly configurable
  # ags            # scriptable in JavaScript — powerful but complex

  # Launcher
  rofi-wayland     # classic choice, lots of themes available
  # fuzzel         # simpler, fast, minimal config needed
  # wofi           # GTK-based, fine but less actively developed

  # Notifications
  dunst            # lightweight, config-file driven
  # mako           # simpler alternative

  # Wallpaper
  swww             # animated wallpaper transitions
  # swaybg         # simpler — just sets a static wallpaper

  # Lock screen
  hyprlock         # made by the Hyprland author, integrates well
  # swaylock       # the classic choice

  # Idle daemon (triggers lock screen after inactivity)
  hypridle         # pairs with hyprlock

  # Screenshots
  grim             # captures the screen
  slurp            # select a region (used together with grim)

  # Clipboard
  wl-clipboard     # wl-copy / wl-paste CLI tools
  cliphist         # clipboard history (wire up to a keybind)

  # Auth popups
  lxqt.lxqt-policykit   # lightweight polkit agent
];
```

### Your Hyprland config

Your `hyprland.conf` goes in `~/Settings/config/common/hyprland/` (create the folder), then symlink it from `home/common.nix`:

```nix
home.file.".config/hypr".source = config.lib.file.mkOutOfStoreSymlink
  "${config.home.homeDirectory}/Settings/config/common/hyprland";
```

The Hyprland wiki has a [full config reference](https://wiki.hyprland.org/Configuring/Configuring-Hyprland/) — start with their example config and strip it back to what you understand.

---

## Niri

Niri is a scrollable-tiling Wayland compositor — instead of tiling into fixed grid layouts, windows arrange in an infinite horizontal scroll. It's newer and quieter than Hyprland, but extremely stable and genuinely pleasant to use daily.

- [Niri Wiki](https://github.com/YaLTeR/niri/wiki) — thorough, well written
- [Niri NixOS setup](https://github.com/YaLTeR/niri/wiki/Getting-Started)
- [niri-flake](https://github.com/sodiboo/niri-flake) — the recommended way to get Niri on NixOS unstable

### flake.nix — add niri-flake as an input

```nix
inputs = {
  nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  home-manager = {
    url = "github:nix-community/home-manager";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  niri = {
    url = "github:sodiboo/niri-flake";
    inputs.nixpkgs.follows = "nixpkgs";
  };
};
```

Then pass `inputs` through to your host module (it's already wired in this template via `home-manager.extraSpecialArgs = { inherit inputs; }`), and add the niri NixOS module:

```nix
# In your nixosConfigurations.YourHostname modules list:
inputs.niri.nixosModules.niri
```

### system/hosts/YourHostname/configuration.nix

```nix
# Niri
programs.niri = {
  enable = true;
};

# XDG portals — needed for screen sharing, file pickers, etc.
xdg.portal = {
  enable = true;
  extraPortals = [ pkgs.xdg-desktop-portal-gnome ];  # or -gtk
  config.niri.default = [ "gnome" "gtk" ];
};
```

### home/youruser.nix

Niri shares most of the same supporting tools as Hyprland:

```nix
home.packages = with pkgs; [
  # --- Niri ecosystem -------------------------------------------------------

  # Bar
  waybar           # works well with niri out of the box
  # ags            # if you want to go deep on customisation

  # Launcher
  fuzzel           # fast, minimal — pairs nicely with niri's aesthetic
  # rofi-wayland   # more powerful if you want it

  # Notifications
  mako             # simple and clean
  # dunst          # more config options

  # Wallpaper
  swww
  # swaybg

  # Lock screen
  swaylock         # most widely used with niri
  # waylock        # simpler alternative

  # Idle
  swayidle         # triggers lock/sleep after inactivity

  # Screenshots
  grim
  slurp

  # Clipboard
  wl-clipboard
  cliphist

  # Auth popups
  lxqt.lxqt-policykit
];
```

### Your Niri config

Niri uses a single `config.kdl` file. Put it in `~/Settings/config/common/niri/` and symlink it:

```nix
home.file.".config/niri".source = config.lib.file.mkOutOfStoreSymlink
  "${config.home.homeDirectory}/Settings/config/common/niri";
```

The Niri wiki has an [annotated example config](https://github.com/YaLTeR/niri/wiki/Configuration:-Overview) that explains every option — it's genuinely one of the better config references out there.

---

## ⚠️ The XDG Portal situation

This catches everyone. XDG portals are how Wayland apps request things from the desktop — file pickers, screen sharing, clipboard access. If you skip this, screen sharing won't work in browsers, file dialogs will be broken in some apps, and you'll spend an afternoon confused.

The short version: make sure you have `xdg.portal.enable = true` and at least one `extraPortals` entry in your `configuration.nix`, matching your compositor. The snippets above include this — don't remove it.

If something feels broken and you can't explain why, `xdg-desktop-portal` is a likely culprit. Check `systemctl --user status xdg-desktop-portal` and look for errors.

---

## KDE + Niri (dual setup)

You don't have to choose. It's completely valid to have KDE as your stable daily driver and Niri as an alternative session you can log into from the display manager — this is actually a great way to learn a WM without committing fully.

To do this, enable both in `configuration.nix`:

```nix
# KDE Plasma
services.desktopManager.plasma6.enable = true;
services.displayManager.sddm = {
  enable = true;
  wayland.enable = true;
};

# Niri (available as an extra session in SDDM)
programs.niri.enable = true;
```

SDDM will show a session picker at login — choose KDE for your normal day, switch to Niri when you want to experiment. Once you're comfortable, you can drop KDE entirely.

---

## Using someone else's config as a reference

There are great community configs out there. When you find one you like, resist the urge to copy it wholesale. Instead:

1. Read it and identify the parts that matter to you
2. Copy only those sections, one at a time
3. Make sure anything that installs packages does so through `youruser.nix`, not through the config file itself

The main thing that breaks when adapting someone else's NixOS config is **hardcoded paths and usernames**. Search for their username and home directory path and replace them with yours.

---

## A real example

[JAJM2006/Nix](https://github.com/JAJM2006/Nix) is the author's own build on top of this template — KDE + Niri dual setup, built from scratch.

> ⚠️ This repo is currently being actively rebuilt. Treat it as a reference for structure and approach rather than something to copy directly.

---

*Back to [README.md](README.md)*
