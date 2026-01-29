# NixOS Configuration 🎨

My personal NixOS configuration featuring niri scrollable-tiling window manager with Tokyo Night theming.

## 🌟 Features

- **Window Manager**: [niri](https://github.com/YaLTeR/niri) - A scrollable-tiling Wayland compositor
- **Theme**: Tokyo Night across all applications
- **Display Manager**: greetd with auto-login
- **Status Bar**: Waybar with system monitoring
- **Launcher**: Rofi
- **Terminal**: Alacritty
- **Notifications**: Dunst
- **Shell**: Zsh with Starship prompt

## 📦 Installation

### Fresh Install

```bash
# Clone the repository
git clone https://github.com/yourusername/nixos-config ~/Settings
cd ~/Settings

# Copy your hardware configuration
sudo cp /etc/nixos/hardware-configuration.nix ~/Settings/system/hosts/YourHostname/

# Update flake.nix with your hostname
# Then build
sudo nixos-rebuild switch --flake .#YourHostname
```

### Updating

```bash
# Using the rebuild script
~/Settings/scripts/rebuild

# Or manually
cd ~/Settings
sudo nixos-rebuild switch --flake .#EliteDesk
```

## 🖥️ Hosts

- **EliteDesk** - Main desktop configuration

## ⌨️ Keybindings

### Window Management
| Keybind | Action |
|---------|--------|
| `Mod + Return` | Launch terminal (Alacritty) |
| `Mod + D` | Application launcher (Rofi) |
| `Mod + Q` | Close focused window |
| `Mod + H/L` | Focus left/right column |
| `Mod + J/K` | Focus up/down window |
| `Mod + Shift + H/J/K/L` | Move window |
| `Mod + F` | Maximize column |
| `Mod + Shift + F` | Fullscreen window |
| `Mod + Space` | Toggle floating |

### Workspaces
| Keybind | Action |
|---------|--------|
| `Mod + Ctrl + Up/Down` | Switch workspace |
| `Mod + Shift + Ctrl + J/K` | Move window to workspace |

### Column Width
| Keybind | Action |
|---------|--------|
| `Mod + 1/2/3/4` | Set column width (25%/50%/75%/100%) |
| `Mod + S` | Switch preset widths |
| `Mod + -/+` | Decrease/increase width by 10% |

### System
| Keybind | Action |
|---------|--------|
| `Print` | Screenshot screen |
| `Mod + Shift + S` | Screenshot selection |
| `Mod + Shift + Alt + S` | Screenshot window |
| `Mod + Shift + E` | Quit niri |
| `XF86Audio*` | Media controls |
| `XF86MonBrightness*` | Brightness controls |

## 📁 Structure

```
Settings/
├── config/              # Application configurations
│   ├── alacritty/      # Terminal config
│   ├── dunst/          # Notification daemon
│   ├── niri/           # Window manager
│   ├── rofi/           # Application launcher
│   ├── starship/       # Shell prompt
│   └── waybar/         # Status bar
├── home/               # Home-manager user config
│   └── juso.nix
├── system/             # NixOS system configuration
│   └── hosts/
│       └── EliteDesk/
├── scripts/            # Utility scripts
│   ├── rebuild        # System rebuild script
│   └── screenshot     # Screenshot helper
├── modules/            # Future modular configs
├── secrets/            # Private configs (gitignored)
├── flake.nix          # Nix flake configuration
└── flake.lock         # Flake lock file
```

## 🎨 Tokyo Night Color Palette

| Color | Hex | Usage |
|-------|-----|-------|
| Background | `#1a1b26` | Main background |
| Foreground | `#c0caf5` | Main text |
| Blue | `#7aa2f7` | Accents, focused |
| Cyan | `#7dcfff` | Info, highlights |
| Green | `#9ece6a` | Success |
| Red | `#f7768e` | Errors, critical |
| Purple | `#bb9af7` | Special |
| Yellow | `#e0af68` | Warnings |

## 🔧 Configuration

### Adding a New Host

1. Create new host directory:
   ```bash
   mkdir -p ~/Settings/system/hosts/NewHost
   ```

2. Copy hardware configuration:
   ```bash
   sudo cp /etc/nixos/hardware-configuration.nix ~/Settings/system/hosts/NewHost/
   ```

3. Create or copy `configuration.nix` for the new host

4. Update `flake.nix` to include the new host

### Customizing

- **Colors**: Edit the color values in `config/waybar/style.css`, `config/rofi/config.rasi`, etc.
- **Keybindings**: Modify `config/niri/config.kdl`
- **System packages**: Edit `system/hosts/EliteDesk/configuration.nix`
- **User packages**: Edit `home/juso.nix`

## 🚀 Installed Packages

### System Tools
- neovim, git, wget, tree
- htop, btop, neofetch
- ripgrep, fd, bat, fzf
- tmux, direnv, eza

### Desktop Environment
- niri, waybar, rofi, dunst
- alacritty, grim, slurp
- brightnessctl, playerctl
- wl-clipboard, cliphist

### Fonts
- FiraCode Nerd Font

### Themes
- Bibata Cursors
- Papirus Icons

## 📝 Notes

- Hardware configuration is machine-specific and excluded from git
- Uses NixOS unstable channel for latest packages
- Flakes enabled for reproducible builds
- Auto-login configured via greetd

## 🙏 Acknowledgments

- [Tokyo Night Theme](https://github.com/tokyo-night/tokyo-night-vscode-theme)
- [niri Window Manager](https://github.com/YaLTeR/niri)
- [NixOS](https://nixos.org/)
- [Home Manager](https://github.com/nix-community/home-manager)

## 📄 License

This configuration is provided as-is for personal use and learning purposes.

---

**Author**: Geordie Mac  
**System**: NixOS 25.11
