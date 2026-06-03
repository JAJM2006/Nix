# Nix Configuration Template

A NixOS configuration using Nix flakes and Home Manager, designed to live at `~/Settings`.

Fork this, run `setup.sh`, and you have a working base to build from.

---

## 🤔 Wait — what even is NixOS?

Good question. Before you run anything, it helps to understand *why* this exists.

Most Linux distros work like this: you install packages by running commands, edit config files scattered across your system, and hope you remember what you changed six months later when something breaks. Your system is the sum of everything you've ever done to it — and that's fragile.

**NixOS works differently.** Your entire system — every package, every service, every setting — is described in a set of plain text files. When you run `rebuild`, NixOS reads those files and makes your system match them exactly. Nothing more, nothing less.

This means:

- **Reproducible** — your config files *are* your system. Clone them onto a new machine and you get the same setup.
- **Rollbackable** — every rebuild creates a new "generation". If an update breaks something, you boot the previous generation and you're back.
- **Readable** — want to know what's installed? Open `home/common.nix`. Everything is in one place, not spread across package manager history logs.

The tradeoff is that NixOS has a learning curve. This template is designed to flatten that curve — you get a working system with sane defaults, and you can learn the details as you go.

> **A note on terminology:** "Nix" refers to the programming language and package manager. "NixOS" is the Linux distribution built on top of it. You'll see both terms a lot.

---

## 📁 How this repo is organised

Once `setup.sh` runs, your config lives at `~/Settings` and looks like this:

```
~/Settings/
├── config/
│   └── common/                               # App configs (shared across machines)
│       ├── alacritty/                        # Terminal emulator config
│       ├── nvim/                             # Neovim / LazyVim config
│       └── starship/                         # Shell prompt config
│
├── home/
│   ├── common.nix                            # Packages and programs for all machines
│   └── youruser.nix                          # Your NixOS-specific home config
│
├── scripts/
│   ├── rebuild                               # Shortcut: rebuild your NixOS system
│   └── maintain                             # Shortcut: common maintenance tasks
│
├── system/
│   ├── hosts/
│   │   └── YourHostname/
│   │       ├── configuration.nix            # System-level config (boot, networking, etc.)
│   │       └── hardware-configuration.nix   # Your hardware — generated on install, gitignored
│   └── secrets/
│       └── (see Secrets section below)
│
├── setup.sh                                 # Run this first
├── flake.nix                                # The entry point — wires everything together
└── flake.lock                               # Pinned dependency versions (commit this)
```

**The key idea:** `config/` holds app config files that are *symlinked* into place, so you can edit them directly and see changes immediately. `home/` and `system/` hold Nix files that declare what's installed and how services are configured — these require a `rebuild` to take effect.

---

## 🖥️ Machines

- **YourHostname** — NixOS desktop (x86_64-linux), renamed by `setup.sh`

---

## 🚀 Quick Start

### 1. Clone the repo

```bash
nix-shell -p git --run "git clone https://github.com/JAJM2006/Nix-Template ~/Settings"
```

### 2. Run setup

```bash
cd ~/Settings
bash setup.sh
```

This asks for your username, hostname, full name, email, timezone, and keyboard layout, then renames placeholder files and replaces placeholder values across the repo. It also copies your hardware config from `/etc/nixos/` and optionally initialises git.

### 3. Build

```bash
rebuild
```

That's it. The `rebuild` script is added to your PATH by `setup.sh`, so you can run it from anywhere once your system is built.

### 4. Reboot

```bash
reboot
```

Log in and you're home.

---

## 📝 Making Changes

### Adding packages

**For all machines** — edit `~/Settings/home/common.nix`:
```nix
home.packages = with pkgs; [
  your-new-package
];
```

**For this machine only** — edit `~/Settings/home/youruser.nix`:
```nix
home.packages = with pkgs; [
  your-linux-only-package
];
```

Then run `rebuild` to apply.

> **Finding packages:** search at [search.nixos.org/packages](https://search.nixos.org/packages). The name in the search results is what you put in the list.

### Modifying app configs

Config files in `~/Settings/config/` are symlinked, so edits take effect immediately — no rebuild needed:

```bash
nvim ~/Settings/config/common/nvim/lua/plugins/plugins.lua  # add a neovim plugin
nvim ~/Settings/config/common/alacritty/alacritty.toml      # change terminal settings
```

Run `rebuild` afterwards if you also made changes to `home/` or `system/`.

### System-level changes

Edit `~/Settings/system/hosts/<YourHostname>/configuration.nix`, then run `rebuild`.

This is where you'd enable services, change boot settings, add kernel modules, and so on.

---

## 🔄 Maintenance

```bash
cd ~/Settings
./scripts/maintain
```

Interactive menu with these options:

- **System Rebuild** — equivalent to running `rebuild`
- **Garbage Collection** — frees disk space by removing old generations; you'll be asked how far back to keep
- **Optimise Store** — deduplicates the Nix store to save space
- **Update Flake** — updates `flake.lock` to pull in the latest package versions

---

## 💾 Saving your config with Git

After `setup.sh`, your `~/Settings` folder is already a git repo. To save your changes:

```bash
cd ~/Settings
git add -A
git commit -m "describe what you changed"
git push
```

Or use the built-in shell shortcuts:

```bash
gpmain "update nvim plugins"   # add, commit, and push to main
gpdev  "wip: trying hyprland"  # add, commit, and push to dev
```

If you haven't set a remote repository yet:

```bash
# Create a repo on GitHub, Codeberg, or wherever — then:
git remote add origin https://github.com/YOU/YOUR_REPO
git push -u origin main
```

### What gets committed (and what doesn't)

`hardware-configuration.nix` is gitignored — it contains UUIDs and partition paths that are unique to your machine. Anyone cloning your config generates their own with `nixos-generate-config`. Everything else — your package lists, app configs, and the flake — is committed and fully portable.

---

## 📦 What's included out of the box

| Tool | What it is |
|------|------------|
| **Zsh** | Your shell, with a sensible config and useful aliases |
| **Starship** | A fast, informative shell prompt |
| **Neovim + LazyVim** | A fully-featured code editor (config in `config/common/nvim/`) |
| **Alacritty** | A fast, GPU-accelerated terminal emulator |
| **bat** | A better `cat` — syntax highlighting in the terminal |
| **eza** | A better `ls` — icons, colour, and git status |
| **ripgrep** | Extremely fast file content search |
| **fd** | A simpler, faster alternative to `find` |
| **fzf** | Fuzzy finder — press Ctrl+R in the terminal for searchable history |
| **btop / htop** | System resource monitors |
| **tmux** | Terminal multiplexer — multiple panes and sessions in one window |
| **git** | Pre-configured with common aliases and the `gpmain`/`gpdev` shortcuts |

---

## 🔐 Secrets

The `system/secrets/` directory is gitignored for `*.age`, `*.key`, `*.pem`, and `*.gpg` files — nothing in there will ever be committed accidentally.

When you're ready to manage secrets properly (SSH keys, API tokens, passwords), look at:

- [sops-nix](https://github.com/Mic92/sops-nix) — the most widely used option, integrates well with flakes
- [agenix](https://github.com/ryantm/agenix) — simpler, uses `age` encryption

Neither is set up in this template — add whichever fits your needs.

---

## 🪟 Want to use Hyprland or Niri?

Standalone window managers are popular in the NixOS community — but wiring one up from scratch is non-obvious the first time. See the dedicated guide:

**[WINDOW_MANAGERS.md](WINDOW_MANAGERS.md)** — covers what a WM needs to replace a DE, the Nix config snippets to get Hyprland or Niri running, the XDG portal situation that bites everyone, and how to run KDE and Niri side-by-side while you're learning.

---

## 📚 Useful links

- [NixOS Manual](https://nixos.org/manual/nixos/stable/) — the official reference
- [Home Manager Manual](https://nix-community.github.io/home-manager/) — docs for the home config options
- [NixOS Package Search](https://search.nixos.org/packages) — find package names
- [MyNixOS](https://mynixos.com) — browse options and generate config snippets
- [Nix Pills](https://nixos.org/guides/nix-pills/) — a gentle intro to how Nix actually works, if you want to go deeper
- [Zero to Nix](https://zero-to-nix.com) — another good beginner-friendly intro

---

*Template by Geordie Mac ([JAJM2006](https://github.com/JAJM2006))*
