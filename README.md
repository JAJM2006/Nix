# Nix Configuration Template

A unified NixOS configuration using Nix flakes and home-manager.
Fork this, rename the placeholders, and make it yours.

## 🖥️ Machines

- **YourHostname** - NixOS desktop (x86_64-linux) — rename this to whatever you call your machine

## 📁 Repository Structure

```
Settings/
├── config/
│   └── common/                               # Cross-platform configurations
│       ├── alacritty/                        # Terminal emulator
│       ├── nvim/                             # Neovim (LazyVim)
│       └── starship/                         # Shell prompt
│
├── home/
│   ├── common.nix                            # Shared home-manager config
│   └── youruser.nix                          # NixOS home-manager (imports common.nix)
│
├── scripts/
│   ├── rebuild                               # Rebuild NixOS
│   └── maintain                              # Maintenance tasks
│
├── system/
│   ├── hosts/
│   │   └── YourHostname/
│   │       ├── configuration.nix            # NixOS system config
│   │       └── hardware-configuration.nix   # Your hardware config (copy from /etc/nixos/)
│   └── Secrets/
│       └── (empty)
│
├── flake.nix
└── flake.lock
```

## 🚀 Quick Start

### Prerequisites

You need a working NixOS install. Use any ISO you like.

### Setup

```bash
nix-shell -p git
git clone https://github.com/YOUR_USERNAME/YOUR_REPO ~/Settings
cd ~/Settings
```

**Rename the placeholders** (see below), then:

```bash
# Copy your hardware config
cp /etc/nixos/hardware-configuration.nix ~/Settings/system/hosts/YourHostname/

# Build
sudo nixos-rebuild switch --flake .#YourHostname
```

### Placeholders to Replace

| Placeholder | What to change it to | Where |
|---|---|---|
| `YourHostname` | Your machine's hostname | `flake.nix`, `scripts/rebuild`, `system/hosts/` directory |
| `youruser` | Your Linux username | `flake.nix`, `home/youruser.nix` filename, `system/hosts/YourHostname/configuration.nix` |
| `Your Name` | Your display name | `home/common.nix` (git config) |
| `your@email.com` | Your email | `home/common.nix` (git config) |
| `Europe/London` | Your timezone | `system/hosts/YourHostname/configuration.nix` |

### Daily Usage

```bash
# Make scripts executable (first time only)
chmod +x ~/Settings/scripts/rebuild ~/Settings/scripts/maintain

cd ~/Settings
rebuild
```

## 📝 Making Changes

### Adding Packages

**For all users** (`home/common.nix`):
```nix
home.packages = with pkgs; [
  your-new-package
];
```

**For NixOS only** (`home/youruser.nix`):
```nix
home.packages = with pkgs; [
  your-linux-package
];
```

### System-Level Changes

Edit `system/hosts/YourHostname/configuration.nix`, then run `rebuild`.

### Choosing a Desktop Environment

In `system/hosts/YourHostname/configuration.nix`, uncomment the DE block you want:

```nix
# GNOME
services.xserver.desktopManager.gnome.enable = true;
services.displayManager.gdm.enable = true;

# KDE Plasma
services.desktopManager.plasma6.enable = true;
services.displayManager.sddm.enable = true;

# Or bring your own (Hyprland, Niri, Sway, etc.)
```

## 🔄 Maintenance

```bash
cd ~/Settings
./scripts/maintain
```

Options: System Rebuild, Garbage Collection, Optimise Store, Update Flake.

## 📦 What's Included (Barebones)

- **Shell**: Zsh with Starship prompt
- **Editor**: Neovim with LazyVim
- **Terminal**: Alacritty
- **Git**: Pre-configured with common aliases
- **Tools**: bat, eza, fd, ripgrep, htop, btop, tmux, fzf

## 📚 Useful Links

- [NixOS Manual](https://nixos.org/manual/nixos/stable/)
- [Home Manager Manual](https://nix-community.github.io/home-manager/)
- [Nix Flakes](https://nixos.wiki/wiki/Flakes)
- [NixOS Package Search](https://search.nixos.org/packages)
- [MyNixOS](https://mynixos.com) — great for browsing options

---

**Template based on work by Geordie Mac (JAJM2006)**
