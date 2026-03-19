# JAJM2006's Nix Configuration

A unified, cross-platform configuration system for NixOS and macOS using Nix flakes, nix-darwin, and home-manager.

## 🖥️ Machines

- **EliteDesk** - NixOS desktop (x86_64-linux)
- **MacBook** - macOS laptop (aarch64-darwin)

## 📁 Repository Structure

```
Settings/
├── config/
│   ├── common/                               # Cross-platform configurations
│   │   ├── alacritty/                        # Terminal emulator
│   │   ├── nvim/                             # Neovim (LazyVim)
│   │   └── starship/                         # Shell prompt
│   ├── darwin/                               # macOS-specific configurations
│   │   └── (empty)                           # Nowt here ATM.
│   └── nixos/                                # Linux-specific configurations
│       ├── dunst/                            # Notification daemon
│       ├── niri/                             # Wayland compositor
│       ├── noctalia/                         # Noctalia shell
│       ├── rofi/                             # Application launcher
│       └── waybar/                           # Status bar
│
├── home/
│   ├── common.nix                            # Shared home-manager config
│   ├── darwin.nix                            # macOS home-manager (imports common.nix)
│   └── juso.nix                              # NixOS home-manager (imports common.nix)
│
├── scripts/
│   ├── rebuild                               # Rebuild NixOS
│   ├── rdarwin                               # Rebuild macOS
│   ├── maintain                              # Maintenance tasks
│   ├── screenshot                            # Screenshot utility
│   ├── wallpaper-rotate                      # Wallpaper rotation
│   └── wallpaper-selector                    # Wallpaper selection
│
├── system/
│   ├── hosts/          
│   │   ├── EliteDesk/
│   │   │   ├── configuration.nix            # NixOS software config file for EliteDesk
│   │   │   └── hardware-configuration.nix   # NixOS hardware config file for EliteDesk
│   │   └── MacBook/    
│   │       └── configuration.nix            # Nix-Darwin software config file for MacBook
│   └── secrets/          
│       └── (empty)                          # Nowt here ATM.
│
├── flake.nix                                # Main flake configuration
└── flake.lock                               # lockfile
```

## 🎯 Features

### Common Features on Both Platforms
- **Shell**: Zsh with Starship prompt
- **Editor**: Neovim with LazyVim configuration
- **Terminal**: Alacritty with custom config
- **Git**: Unified configuration with custom aliases
- **Tools**: bat, eza, fd, ripgrep, htop, tmux, fzf, btop

### NixOS-Specific (EliteDesk)
- **Window Manager**: Niri (Wayland compositor)
- **Desktop**: Waybar, Rofi, Dunst
- **Gaming**: Steam with Gamescope, GameMode, MangoHud
- **Display Manager**: Greetd with tuigreet
- **File Manager**: Thunar with plugins
- **Privacy**: Tor daemon

### macOS-Specific (MacBook)
- **System Defaults**: Dock, Finder, keyboard settings
- **Package Manager**: Homebrew integration
- **Trackpad**: Tap to click, three-finger drag
- **Keyboard**: Caps Lock → Control remapping

## 🚀 Quick Start

### First Time Setup

#### NixOS (EliteDesk) - Use any install ISO you wish.
```bash
nix-shell -p git
# Clone the repository
git clone https://github.com/JAJM2006/Nix ~/Settings
cd ~/Settings

# Build and activate
sudo nixos-rebuild switch --flake .#EliteDesk
```

#### macOS (MacBook) - Install Nix-Darwin.
```bash
# Clone the repository
git clone https://github.com/JAJM20006/Nix ~/Settings
cd ~/Settings

# Install nix-darwin (first time only)
nix run nix-darwin -- switch --flake ~/Settings#MacBook

# Subsequent rebuilds use the script
./scripts/rdarwin
```

### Daily Usage - GO TO "~/Settings/scripts" AND "Chmod +x"

#### On NixOS
```bash
cd ~/Settings
rebuild
```

#### On macOS
```bash
cd ~/Settings
rdarwin
```

## 📝 Making Changes

### Adding Packages

**For both platforms** (edit `home/common.nix`):
```nix
home.packages = with pkgs; [
  neovim
  alacritty
  your-new-package  # Add here
];
```

**For NixOS only** (edit `home/juso.nix`):
```nix
home.packages = with pkgs; [
  your-linux-package  # Add here
];
```

**For macOS only** (edit `home/darwin.nix`):
```nix
home.packages = with pkgs; [
  your-macos-package  # Add here
];
```

### Modifying Configurations

All configuration files are symlinked from `~/Settings/config/`:

```bash
# Edit configs directly in the repo
nvim ~/Settings/config/common/nvim/init.lua
nvim ~/Settings/config/nixos/niri/config.kdl

# Changes apply immediately (configs are symlinked)
# Rebuild to update packages/system settings
rebuild (NixOS) OR rdarwin (MacOS)
```

### System-Level Changes

**NixOS**: Edit `system/hosts/EliteDesk/configuration.nix`
**macOS**: Edit `system/hosts/MacBook/configuration.nix`

Then rebuild.

## 🔄 Syncing Between Machines

```bash
# On EliteDesk (after making changes)
cd ~/Settings
git add -A
git commit -m "Update configs"
git push origin main

# On MacBook
cd ~/Settings
git pull origin main
rdarwin
```

## 🛠️ Maintenance

### Update System Packages
```bash
cd ~/Settings
./scripts/maintain
```

### Garbage Collection
```bash
# NixOS
sudo nix-collect-garbage -d

# macOS (runs automatically weekly)
nix-collect-garbage -d
```

### Update Flake Inputs
```bash
cd ~/Settings
nix flake update
./scripts/rebuild  # or ./scripts/rdarwin
```

## 📦 Key Packages

### Development
- **Neovim**: LazyVim with LSPs (nixd, lua-language-server, stylua)
- **Git**: Custom aliases (st, co, cm, gpdev, gpmain)
- **Shell**: Zsh with case-insensitive completion

### System Utilities
- **Terminal**: Alacritty (GPU-accelerated)
- **File Tools**: eza (ls), bat (cat), fd (find), ripgrep (grep)
- **Monitoring**: htop, btop
- **Multiplexer**: tmux
- **Search**: fzf

### NixOS Desktop
- **Compositor**: Niri
- **Bar**: Waybar
- **Launcher**: Rofi
- **Notifications**: Dunst
- **Screenshots**: Grim + Slurp
- **Wallpapers**: swww
- **Clipboard**: wl-clipboard, cliphist

## 🎨 Customization

### Git Workflow Functions
Custom git functions available in the shell:
```bash
gpdev "commit message"   # Add, commit, push to dev branch
gpmain "commit message"  # Add, commit, push to main branch
gs                       # Git status (alias)
```

### Wallpaper Functions (NixOS)
```bash
wall path/to/image.jpg   # Set wallpaper with transition
wallrandom               # Random wallpaper from ~/Pictures/Wallpapers
```

## 📚 Documentation

- [NixOS Manual](https://nixos.org/manual/nixos/stable/)
- [nix-darwin Manual](https://daiderd.com/nix-darwin/manual/index.html)
- [Home Manager Manual](https://nix-community.github.io/home-manager/)
- [Nix Flakes](https://nixos.wiki/wiki/Flakes)

## 🏗️ Architecture

This configuration uses a **shared base + platform-specific overrides** pattern:

1. **Common Config** (`home/common.nix`): Cross-platform packages and settings
2. **Platform Configs**: Import common.nix and add platform-specific items
   - `home/juso.nix`: NixOS-specific
   - `home/darwin.nix`: macOS-specific
3. **System Configs**: Platform-specific system settings
   - `system/hosts/EliteDesk/`: NixOS system configuration
   - `system/hosts/MacBook/`: nix-darwin system configuration

This minimizes duplication while maintaining platform flexibility.

## 📊 System Information

### EliteDesk (NixOS)
- **OS**: NixOS 25.11
- **Kernel**: Latest (linuxPackages_latest)
- **Display**: Wayland (Niri)
- **Audio**: PipeWire
- **Shell**: Zsh with Starship

### MacBook (macOS)
- **OS**: macOS with nix-darwin
- **Architecture**: Apple Silicon (aarch64)
- **Shell**: Zsh with Starship
- **Package Managers**: Nix + Homebrew

## 🤝 Contributing and License 📄

This is a personal configuration, but feel free to fork and adapt for your own use!
not YET under SPARK License Agreement - Comming soon


└── > This means that anyone who uses any of the work in this repo, in their own work and then publishes it, AFTER SLA will have to opensource their repo too. This does not affect private and personal work. AGAIN, not yet signed. 

---

**Author**: Geordie Mac (JAJM2006)  
**Last Updated**: January 2026
