#!/usr/bin/env bash
# ==============================================================================
# SETUP.SH — First-time configuration
# ==============================================================================
# Run this once after cloning. It replaces all placeholder values across the
# repo with your actual username and hostname, then optionally sets up git.
# ==============================================================================

set -e

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# ==============================================================================
# HELPERS
# ==============================================================================

green()  { echo -e "\033[0;32m$*\033[0m"; }
yellow() { echo -e "\033[0;33m$*\033[0m"; }
red()    { echo -e "\033[0;31m$*\033[0m"; }
bold()   { echo -e "\033[1m$*\033[0m"; }

ask() {
    # ask <prompt> <default>
    local prompt="$1" default="$2" reply
    read -rp "$(bold "$prompt") [${default}]: " reply
    echo "${reply:-$default}"
}

confirm() {
    # confirm <prompt>  →  returns 0 for yes, 1 for no
    local reply
    read -rp "$(bold "$1") [y/N]: " reply
    [[ "$reply" =~ ^[Yy]$ ]]
}

# ==============================================================================
# WELCOME
# ==============================================================================

echo ""
bold "========================================"
bold "  NixOS Config Template — First Setup  "
bold "========================================"
echo ""
echo "This script will personalise the template for your machine."
echo "It only edits text files — nothing is built or installed yet."
echo ""

# ==============================================================================
# GATHER INFO
# ==============================================================================

USERNAME=$(ask "Your Linux username (e.g. alice)"       "youruser")
HOSTNAME=$(ask "Your machine hostname (e.g. nixbox)"    "YourHostname")
FULLNAME=$(ask "Your full name (for git config)"        "Your Name")
EMAIL=$(ask    "Your email (for git config)"            "your@email.com")
TIMEZONE=$(ask "Your timezone (e.g. America/New_York)"  "Europe/London")
KEYMAP=$(ask   "Your keyboard layout (e.g. us, uk, de)" "us")

echo ""
yellow "About to make the following changes across ~/Settings:"
echo "  youruser     →  $USERNAME"
echo "  YourHostname →  $HOSTNAME"
echo "  Your Name    →  $FULLNAME"
echo "  your@email.com → $EMAIL"
echo "  Europe/London  → $TIMEZONE"
echo "  Keyboard: gb  →  $KEYMAP"
echo ""

if ! confirm "Looks good? Continue?"; then
    echo "Aborted. No changes made."
    exit 0
fi

# ==============================================================================
# RENAME FILES AND DIRECTORIES
# ==============================================================================

echo ""
echo "Renaming files..."

# Rename home/youruser.nix → home/<username>.nix
if [[ -f "$REPO_DIR/home/youruser.nix" ]]; then
    mv "$REPO_DIR/home/youruser.nix" "$REPO_DIR/home/${USERNAME}.nix"
    green "  home/youruser.nix → home/${USERNAME}.nix"
fi

# Rename system/hosts/YourHostname/ → system/hosts/<hostname>/
if [[ -d "$REPO_DIR/system/hosts/YourHostname" ]]; then
    mv "$REPO_DIR/system/hosts/YourHostname" "$REPO_DIR/system/hosts/${HOSTNAME}"
    green "  system/hosts/YourHostname/ → system/hosts/${HOSTNAME}/"
fi

# ==============================================================================
# FIND AND REPLACE IN FILES
# ==============================================================================

echo "Updating file contents..."

# Files to search and replace in
FILES=(
    "$REPO_DIR/flake.nix"
    "$REPO_DIR/scripts/rebuild"
    "$REPO_DIR/scripts/maintain"
    "$REPO_DIR/home/${USERNAME}.nix"
    "$REPO_DIR/home/common.nix"
    "$REPO_DIR/system/hosts/${HOSTNAME}/configuration.nix"
)

do_replace() {
    local file="$1" from="$2" to="$3"
    if [[ -f "$file" ]] && grep -q "$from" "$file"; then
        sed -i "s|${from}|${to}|g" "$file"
    fi
}

for f in "${FILES[@]}"; do
    [[ -f "$f" ]] || continue

    do_replace "$f" "youruser"        "$USERNAME"
    do_replace "$f" "YourHostname"    "$HOSTNAME"
    do_replace "$f" "Your Name"       "$FULLNAME"
    do_replace "$f" "your@email.com"  "$EMAIL"
    do_replace "$f" "Europe/London"   "$TIMEZONE"

    # Keyboard layout — only replace in configuration.nix to avoid false hits
    if [[ "$f" == *"configuration.nix" ]]; then
        do_replace "$f" 'layout  = "gb"'  "layout  = \"${KEYMAP}\""
        do_replace "$f" 'keyMap = "uk"'   "keyMap = \"${KEYMAP}\""
        do_replace "$f" 'layout "gb"'     "layout \"${KEYMAP}\""
    fi

    green "  updated: ${f#$REPO_DIR/}"
done

# ==============================================================================
# COPY HARDWARE CONFIG
# ==============================================================================

echo ""
HARDWARE_SRC="/etc/nixos/hardware-configuration.nix"
HARDWARE_DST="$REPO_DIR/system/hosts/${HOSTNAME}/hardware-configuration.nix"

if [[ -f "$HARDWARE_SRC" ]]; then
    cp "$HARDWARE_SRC" "$HARDWARE_DST"
    green "Copied hardware-configuration.nix from /etc/nixos/"
else
    yellow "Could not find /etc/nixos/hardware-configuration.nix"
    yellow "Copy it manually: cp /etc/nixos/hardware-configuration.nix $HARDWARE_DST"
fi

# ==============================================================================
# GIT SETUP
# ==============================================================================

echo ""
if confirm "Set up a git repository for your config?"; then

    echo ""
    REMOTE=$(ask "Remote URL (leave blank to skip)" "")

    cd "$REPO_DIR"

    if [[ ! -d ".git" ]]; then
        git init
        green "Initialised git repo"
    fi

    git add -A
    git commit -m "Initial config: ${USERNAME}@${HOSTNAME}"
    green "Created initial commit"

    if [[ -n "$REMOTE" ]]; then
        git remote add origin "$REMOTE" 2>/dev/null || git remote set-url origin "$REMOTE"
        git branch -M main
        git push -u origin main
        green "Pushed to $REMOTE"
    else
        yellow "No remote set — run 'git remote add origin <url>' when ready"
    fi
fi

# ==============================================================================
# DONE
# ==============================================================================

echo ""
bold "========================================"
green "  Setup complete!"
bold "========================================"
echo ""
echo "Next steps:"
echo "  1. Make scripts executable:"
echo "     chmod +x ~/Settings/scripts/rebuild ~/Settings/scripts/maintain"
echo ""
echo "  2. Choose a desktop environment — edit:"
echo "     ~/Settings/system/hosts/${HOSTNAME}/configuration.nix"
echo "     (uncomment the GNOME, KDE, or custom WM block)"
echo ""
echo "  3. Build your system:"
echo "     cd ~/Settings && sudo nixos-rebuild switch --flake .#${HOSTNAME}"
echo ""
