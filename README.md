# Nix Configuration Template

A NixOS configuration using Nix flakes and home-manager, designed to live at `~/Settings`.

Fork this, run `setup.sh`, and you have a working base to rice from.

## 🖥️ Machines

- **YourHostname** - NixOS desktop (x86_64-linux) — renamed by `setup.sh`

## 📁 Repository Structure

```
~/Settings/
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
│   │       └── hardware-configuration.nix   # Your hardware (gitignored — see below)
│   └── Secrets/
│       └── (empty — see Secrets section)
│
├── setup.sh                                 # Run this first
├── .gitignore
├── flake.nix
└── flake.lock
```

## 🚀 Quick Start

### 1. Clone the repo

```bash
nix-shell -p git
git clone https://github.com/YOUR_USERNAME/YOUR_REPO ~/Settings
cd ~/Settings
```

### 2. Run setup

```bash
bash setup.sh
```

This will ask for your username, hostname, full name, email, timezone, and keyboard layout, then rename all the placeholder files and replace all placeholder values across the repo in one go. It also copies your hardware config from `/etc/nixos/` and optionally initialises git.

### 3. Choose a desktop environment

Open `~/Settings/system/hosts/<YourHostname>/configuration.nix` and uncomment one of the DE blocks (GNOME, KDE, or bring your own WM).

### 4. Build

```bash
chmod +x ~/Settings/scripts/rebuild ~/Settings/scripts/maintain
cd ~/Settings
rebuild
```

## 📝 Making Changes

### Adding packages

**For all machines** (`~/Settings/home/common.nix`):
```nix
home.packages = with pkgs; [
  your-new-package
];
```

**For this machine only** (`~/Settings/home/youruser.nix`):
```nix
home.packages = with pkgs; [
  your-linux-package
];
```

### Modifying configs

Config files are symlinked from `~/Settings/config/`, so edits there take effect immediately without a rebuild:

```bash
nvim ~/Settings/config/common/nvim/lua/plugins/plugins.lua
nvim ~/Settings/config/common/alacritty/alacritty.toml
```

Run `rebuild` afterwards to apply any package or system-level changes.

### System-level changes

Edit `~/Settings/system/hosts/<YourHostname>/configuration.nix`, then run `rebuild`.

## 🔄 Maintenance

```bash
cd ~/Settings
./scripts/maintain
```

Options: System Rebuild, Garbage Collection, Optimise Store, Update Flake.

## 💾 Backing Up Your Config to Git

Your config is already a git repo after running `setup.sh`. To save changes:

```bash
cd ~/Settings
git add -A
git commit -m "describe what you changed"
git push
```

Or use the built-in shortcuts from your shell:

```bash
gpmain "update nvim plugins"   # add, commit, push to main
gpdev  "wip: trying hyprland"  # add, commit, push to dev
```

If you haven't set a remote yet:

```bash
# Create a repo on GitHub or Codeberg or wherever, then:
git remote add origin https://github.com/YOU/YOUR_REPO
git push -u origin main
```

### What gets committed

`hardware-configuration.nix` is gitignored — it contains UUIDs and partition paths specific to your machine. Anyone cloning your config generates their own with `nixos-generate-config`. Everything else (your package lists, configs, flake) is committed and portable.

## 📦 What's Included

- **Shell**: Zsh with Starship prompt
- **Editor**: Neovim with LazyVim (config in `config/common/nvim/`)
- **Terminal**: Alacritty (config in `config/common/alacritty/`)
- **Git**: Pre-configured with common aliases and push shortcuts
- **Tools**: bat, eza, fd, ripgrep, htop, btop, tmux, fzf

## 🔐 Secrets

The `system/Secrets/` directory is gitignored for `*.age`, `*.key`, etc. When you're ready to manage secrets properly, look at:

- [sops-nix](https://github.com/Mic92/sops-nix) — most popular, integrates well with flakes
- [agenix](https://github.com/ryantm/agenix) — simpler, age-based

## 📚 Useful Links

- [NixOS Manual](https://nixos.org/manual/nixos/stable/)
- [Home Manager Manual](https://nix-community.github.io/home-manager/)
- [Nix Flakes](https://nixos.wiki/wiki/Flakes)
- [NixOS Package Search](https://search.nixos.org/packages)
- [MyNixOS](https://mynixos.com) — browse options and generate config snippets

---

**Template by Geordie Mac (JAJM2006)**
