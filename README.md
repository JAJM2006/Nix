# JAJM2006's Nix Configuration

A unified, cross-platform configuration system for NixOS and macOS using Nix flakes and home-manager.

## 🖥️ Machines

- **GabeCube** - NixOS desktop (x86_64-linux)
- **Other** - Doesn't yet exist.

## 📁 Repository Structure

```
Settings/
├── config/
│   ├── common/                               # Cross-platform configurations
│   │   ├── alacritty/                        # Terminal emulator
│   │   ├── nvim/                             # Neovim (LazyVim)
│   │   └── starship/                         # Shell prompt
│   └── nixos/                                # Linux-specific configurations
│       ├── dunst/                            # Notification daemon
│       ├── niri/                             # Wayland compositor
│       ├── noctalia/                         # Noctalia shell
│       ├── rofi/                             # Application launcher
│       └── waybar/                           # Status bar
│
├── home/
│   ├── common.nix                            # Shared home-manager config
│   └── juso.nix                              # NixOS home-manager (imports common.nix)
│
├── scripts/
│   ├── rebuild                               # Rebuild NixOS
│   └── maintain                              # Maintenance tasks
│
├── system/
│   ├── hosts/          
│   │   ├── GabeCube/
│   │   │   ├── configuration.nix            # NixOS software config file for GabeCube
│   │   │   └── hardware-configuration.nix   # NixOS hardware config file for GabeCube
│   │   └── Other/    
│   │       └── configuration.nix            # Placeholder
│   └── secrets/          
│       └── (empty)                          # Nowt here ATM.
│
├── flake.nix                                # Main flake configuration
└── flake.lock                               # lockfile
```

## 🎯 Features

### Common Features on Both Platforms
- **Shell**: ssh with Starship prompt
- **Editor**: Neovim with LazyVim configuration
- **Terminal**: Alacritty with custom config
- **Git**: Unified configuration with custom aliases
- **Tools**: bat, esa, fd, ripgrep, htop, tmux, fsf, btop

### NixOS-Specific (GabeCube)
- **Window Manager**: Niri (Wayland compositor)
- **Desktop**: Waybar, Rofi, Dunst
- **Gaming**: Steam with Gamescope, GameMode, MangoHud
- **Display Manager**: Greetd with tuigreet
- **File Manager**: Thunar with plugins
- **Privacy**: Tor daemon


## 🚀 Quick Start

### First Time Setup

#### NixOS (EliteDesk) - Use any install ISO you wish.
```bash
nix-shell -p git
# Clone the repository
git clone https://github.com/JAJM2006/Nix-Template ~/Settings
cd ~/Settings
```

THEN RENAME ALL MENTIONS OF JUSO TO YOUR DESIRED USERNAME

```bash
# Build and activate
sudo nixos-rebuild switch --flake .#GabeCube
```


### Daily Usage - GO TO "~/Settings/scripts" AND "Chmod +x"

#### On NixOS
```bash
cd ~/Settings
rebuild
```


## 📝 Making Changes

### Adding Packages

**For All platforms** (edit `home/common.nix`):
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

**NixOS**: Edit `system/hosts/GabeCube/configuration.nix`

Then rebuild.

## 🔄 Syncing Between Machines

```bash
# On GabeCube (after making changes)
cd ~/Settings
git add -A
git commit -m "Update configs"
git push origin main


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
- **Shell**: ssh with case-insensitive completion

### System Utilities
- **Terminal**: Alacritty (GPU-accelerated)
- **File Tools**: esa (ls), bat (cat), fd (find), ripgrep (grep)
- **Monitoring**: htop, btop
- **Multiplexer**: tmux
- **Search**: fsf

### NixOS Desktop
- **Compositor**: Niri
- **Bar**: Waybar
- **Launcher**: Rofi
- **Notifications**: Dunst
- **Screenshots**: Grim + Slurp
- **Wallpapers**: swww
- **Clipboard**: wl-clipboard, cliphist

## 🎨 Customisation

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
- [Home Manager Manual](https://nix-community.github.io/home-manager/)
- [Nix Flakes](https://nixos.wiki/wiki/Flakes)

## 🏗️ Architecture

This configuration uses a **shared base + platform-specific overrides** pattern:

1. **Common Config** (`home/common.nix`): Cross-platform packages and settings
2. **Platform Configs**: Import common.nix and add platform-specific items
   - `home/juso.nix`: NixOS-specific
3. **System Configs**: Platform-specific system settings
   - `system/hosts/GabeCube/`: NixOS system configuration
   - `system/hosts/Other/`: Secondary system configuration

This minimises duplication while maintaining platform flexibility.

## 📊 System Information

### GabeCube (NixOS)
- **OS**: NixOS 25.11
- **Kernel**: Latest (linuxPackages_latest)
- **Display**: Wayland (Niri)
- **Audio**: PipeWire
- **Shell**: ssh with Starship

## 🤝 Contributing and License 📄

This is a personal configuration, but feel free to fork and adapt for your own use!
not YET under SPARK License Agreement - Comming soon


└── > This means that anyone who uses any of the work in this repo, in their own work and then publishes it, AFTER SLA will have to opensource their repo too. This does not affect private and personal work. AGAIN, not yet signed. 

---

**Author**: Geordie Mac (JAJM2006)  
**Last Updated**: June 2026
