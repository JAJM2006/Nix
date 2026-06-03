#!/usr/bin/env bash
# ==============================================================================
# SETUP.SH — First-time configuration
# ==============================================================================
# Run this once after cloning. It replaces all placeholder values across the
# repo with your actual username and hostname, then optionally sets up git.
#
# Safe to re-run — it only edits text files and copies hardware config.
# Nothing is built or installed until you run rebuild yourself.
# ==============================================================================

set -e

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# ==============================================================================
# GUM BOOTSTRAP
# ==============================================================================
# gum makes the prompts pretty. If it's not installed yet (likely on a fresh
# NixOS install), we drop into a nix-shell that has it just for this script.
# ==============================================================================

if ! command -v gum &>/dev/null; then
    echo ""
    echo "  'gum' not found — launching a temporary nix-shell that has it."
    echo "  This is normal on a fresh install. It may take a moment."
    echo ""
    exec nix-shell -p gum --run "bash $0 $*"
fi

# ==============================================================================
# HELPERS
# ==============================================================================

title()   { gum style --bold --foreground 212 "$*"; }
success() { gum style --foreground 2   "  ✔  $*"; }
warn()    { gum style --foreground 214 "  ⚠  $*"; }
info()    { gum style --foreground 111 "  →  $*"; }

ask() {
    # ask <prompt> <default>
    gum input --prompt "  $1 " --placeholder "$2" --value "$2"
}

confirm() {
    # confirm <prompt>  →  returns 0 for yes, 1 for no
    gum confirm "  $1"
}

# ==============================================================================
# WELCOME
# ==============================================================================

clear
echo ""
gum style \
    --border rounded \
    --border-foreground 212 \
    --padding "1 4" \
    --bold \
    "NixOS Config Template — First Setup"
echo ""
gum style --foreground 245 \
    "This script personalises the template for your machine." \
    "It only edits text files — nothing is built yet."
echo ""

# ==============================================================================
# GATHER INFO
# ==============================================================================

title "Tell me about your machine"
echo ""

USERNAME=$(ask "Your Linux username (e.g. alice)"        "youruser")
HOSTNAME=$(ask "Your machine hostname (e.g. nixbox)"     "YourHostname")
FULLNAME=$(ask "Your full name (for git config)"         "Your Name")
EMAIL=$(ask    "Your email (for git config)"             "your@email.com")
TIMEZONE=$(ask "Your timezone (e.g. Europe/London)"      "Europe/London")

echo ""
gum style --foreground 245 "  Common locales: en_GB.UTF-8 · en_US.UTF-8 · de_DE.UTF-8 · fr_FR.UTF-8"
echo ""
LOCALE=$(ask   "Your locale"                                 "en_US.UTF-8")

echo ""
gum style --foreground 245 "  Keyboard layout codes: us · gb · de · fr · es · it · pt · ru"
echo ""
KEYMAP=$(ask "Your keyboard layout code" "us")

# ==============================================================================
# CHOOSE DESKTOP ENVIRONMENT
# ==============================================================================

echo ""
title "Choose a desktop environment"
echo ""
gum style --foreground 245 "  Not sure? KDE Plasma is the most familiar if you're coming from Windows."
echo ""

DE=$(gum choose \
    "KDE Plasma 6 (recommended)" \
    "GNOME" \
    "None — I'll configure my own WM")

echo ""
success "Selected: $DE"

# ==============================================================================
# CONFIRM
# ==============================================================================

echo ""
title "About to make these changes:"
echo ""
gum style --border normal --padding "0 2" \
    "  youruser        →  $USERNAME" \
    "  YourHostname    →  $HOSTNAME" \
    "  Your Name       →  $FULLNAME" \
    "  your@email.com  →  $EMAIL" \
    "  Timezone        →  $TIMEZONE" \
    "  Locale          →  $LOCALE" \
    "  Keyboard        →  $KEYMAP" \
    "  Desktop         →  $DE"
echo ""

if ! confirm "Looks good? Continue?"; then
    warn "Aborted. No changes made."
    exit 0
fi

echo ""

# ==============================================================================
# RENAME FILES AND DIRECTORIES
# ==============================================================================

title "Renaming files and directories..."
echo ""

if [[ -f "$REPO_DIR/home/youruser.nix" ]]; then
    mv "$REPO_DIR/home/youruser.nix" "$REPO_DIR/home/${USERNAME}.nix"
    success "home/youruser.nix  →  home/${USERNAME}.nix"
fi

if [[ -d "$REPO_DIR/system/hosts/YourHostname" ]]; then
    mv "$REPO_DIR/system/hosts/YourHostname" "$REPO_DIR/system/hosts/${HOSTNAME}"
    success "system/hosts/YourHostname/  →  system/hosts/${HOSTNAME}/"
else
    warn "Could not find system/hosts/YourHostname/ — skipping directory rename."
    warn "If your folder is named differently, rename it manually."
fi

if [[ -d "$REPO_DIR/config/nixos/YourHostname" ]]; then
    mv "$REPO_DIR/config/nixos/YourHostname" "$REPO_DIR/config/nixos/${HOSTNAME}"
    success "config/nixos/YourHostname/  →  config/nixos/${HOSTNAME}/"
else
    warn "Could not find config/nixos/YourHostname/ — skipping directory rename."
fi

# ==============================================================================
# FIND AND REPLACE IN FILES
# ==============================================================================

title "Updating file contents..."
echo ""

CONFIG_NIX="$REPO_DIR/system/hosts/${HOSTNAME}/configuration.nix"

FILES=(
    "$REPO_DIR/flake.nix"
    "$REPO_DIR/scripts/rebuild"
    "$REPO_DIR/home/${USERNAME}.nix"
    "$REPO_DIR/home/common.nix"
    "$CONFIG_NIX"
)

do_replace() {
    local file="$1" from="$2" to="$3"
    if [[ -f "$file" ]] && grep -qF "$from" "$file"; then
        sed -i "s|${from}|${to}|g" "$file"
    fi
}

for f in "${FILES[@]}"; do
    [[ -f "$f" ]] || { warn "Not found, skipping: ${f#$REPO_DIR/}"; continue; }

    do_replace "$f" "youruser"       "$USERNAME"
    do_replace "$f" "YourHostname"   "$HOSTNAME"
    do_replace "$f" "Your Name"      "$FULLNAME"
    do_replace "$f" "your@email.com" "$EMAIL"
    do_replace "$f" "Europe/London"  "$TIMEZONE"
    do_replace "$f" "en_GB.UTF-8"    "$LOCALE"

    success "Updated: ${f#$REPO_DIR/}"
done

# ==============================================================================
# KEYBOARD LAYOUT
# ==============================================================================
# configuration.nix has two separate keyboard settings:
#   xkb.layout  — X11/Wayland layout code (e.g. "gb", "us", "de")
#   console.keyMap — TTY keymap name, which sometimes differs:
#     gb layout → "uk" keymap   (the one special case worth handling)
#     everything else → same code for both
# ==============================================================================

echo ""
title "Setting keyboard layout..."
echo ""

if [[ -f "$CONFIG_NIX" ]]; then
    # Decide the console keymap
    if [[ "$KEYMAP" == "gb" ]]; then
        CONSOLE_KEYMAP="uk"
    else
        CONSOLE_KEYMAP="$KEYMAP"
    fi

    python3 - "$CONFIG_NIX" "$KEYMAP" "$CONSOLE_KEYMAP" <<'PYEOF'
import sys, re

path, xkb_layout, console_keymap = sys.argv[1], sys.argv[2], sys.argv[3]
text = open(path).read()

# Replace xkb layout (inside the services.xserver.xkb block)
text = re.sub(r'(xkb\s*=\s*\{[^}]*layout\s*=\s*")[^"]*(")', rf'\g<1>{xkb_layout}\2', text, flags=re.DOTALL)

# Replace console keyMap
text = re.sub(r'(console\.keyMap\s*=\s*")[^"]*(")', rf'\g<1>{console_keymap}\2', text)

open(path, 'w').write(text)
PYEOF
    success "xkb.layout = \"$KEYMAP\",  console.keyMap = \"$CONSOLE_KEYMAP\""
else
    warn "Could not find configuration.nix — keyboard layout not set"
fi

# ==============================================================================
# UNCOMMENT CHOSEN DESKTOP ENVIRONMENT
# ==============================================================================
# Uses Python to reliably uncomment the right block. Each DE section is
# bounded by its own comment header, so we only touch the chosen one.
# ==============================================================================

echo ""
title "Enabling desktop environment..."
echo ""

if [[ -f "$CONFIG_NIX" ]]; then
    case "$DE" in

        "KDE Plasma 6 (recommended)")
            python3 - "$CONFIG_NIX" <<'PYEOF'
import re, sys

path = sys.argv[1]
text = open(path).read()

# Match the KDE block: from its header comment up to (not including) the next header
kde_block_re = re.compile(
    r'([ \t]*# --- KDE Plasma 6.*?)'   # KDE header
    r'(?=[ \t]*# --- )',                # stop before the next header
    re.DOTALL
)

def uncomment_kde(m):
    block = m.group(1)
    # Remove the leading '#' and one space from each commented-out line
    block = re.sub(r'^([ \t]*)# (services\.|  enable|  wayland)', r'\1\2', block, flags=re.MULTILINE)
    return block

text = kde_block_re.sub(uncomment_kde, text)
open(path, 'w').write(text)
PYEOF
            success "KDE Plasma 6 enabled"
            ;;

        "GNOME")
            python3 - "$CONFIG_NIX" <<'PYEOF'
import re, sys

path = sys.argv[1]
text = open(path).read()

gnome_block_re = re.compile(
    r'([ \t]*# --- GNOME.*?)'
    r'(?=[ \t]*# --- )',
    re.DOTALL
)

def uncomment_gnome(m):
    block = m.group(1)
    block = re.sub(r'^([ \t]*)# (services\.)', r'\1\2', block, flags=re.MULTILINE)
    return block

text = gnome_block_re.sub(uncomment_gnome, text)
open(path, 'w').write(text)
PYEOF
            success "GNOME enabled"
            ;;

        "None — I'll configure my own WM")
            success "No DE enabled — all blocks left commented out"
            info "Edit system/hosts/${HOSTNAME}/configuration.nix to configure your WM"
            ;;
    esac
else
    warn "Could not find configuration.nix — DE not configured automatically"
    warn "Edit system/hosts/${HOSTNAME}/configuration.nix manually"
fi

# ==============================================================================
# HARDWARE CONFIG
# ==============================================================================

echo ""
title "Hardware configuration..."
echo ""

HARDWARE_SRC="/etc/nixos/hardware-configuration.nix"
HARDWARE_DST="$REPO_DIR/system/hosts/${HOSTNAME}/hardware-configuration.nix"

if [[ -f "$HARDWARE_SRC" ]]; then
    cp "$HARDWARE_SRC" "$HARDWARE_DST"
    success "Copied hardware-configuration.nix from /etc/nixos/"
else
    warn "Could not find /etc/nixos/hardware-configuration.nix"
    info  "Copy it manually when you have it:"
    info  "  cp /etc/nixos/hardware-configuration.nix $HARDWARE_DST"
fi

# ==============================================================================
# MAKE SCRIPTS EXECUTABLE
# ==============================================================================

echo ""
title "Making scripts executable..."
echo ""

chmod +x "$REPO_DIR/scripts/rebuild" "$REPO_DIR/scripts/maintain" 2>/dev/null \
    && success "scripts/rebuild and scripts/maintain are now executable" \
    || warn "Could not chmod scripts — run: chmod +x ~/Settings/scripts/rebuild ~/Settings/scripts/maintain"

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
        success "Initialised git repo"
    fi

    git add -A
    git commit -m "Initial config: ${USERNAME}@${HOSTNAME}"
    success "Created initial commit"

    if [[ -n "$REMOTE" && "$REMOTE" != "skip" ]]; then
        git remote add origin "$REMOTE" 2>/dev/null \
            || git remote set-url origin "$REMOTE"
        git branch -M main
        git push -u origin main
        success "Pushed to $REMOTE"
    else
        warn "No remote set — run 'git remote add origin <url>' when ready"
    fi
fi

# ==============================================================================
# DONE
# ==============================================================================

echo ""
gum style \
    --border rounded \
    --border-foreground 2 \
    --padding "1 4" \
    --bold \
    "  Setup complete!  "
echo ""
info "Next steps:"
echo ""

if [[ "$DE" == "None — I'll configure my own WM" ]]; then
    gum style --padding "0 2" \
        "1.  Configure your WM in system/hosts/${HOSTNAME}/configuration.nix" \
        "" \
        "2.  Build your system:" \
        "      cd ~/Settings && rebuild" \
        "" \
        "3.  Reboot and enjoy."
else
    gum style --padding "0 2" \
        "1.  Build your system:" \
        "      cd ~/Settings && rebuild" \
        "" \
        "2.  Reboot and log in to ${DE%%(*}" \
        "" \
        "3.  Tweak to your heart's content."
fi
echo ""    "This script personalises the template for your machine." \
    "It only edits text files — nothing is built yet."
echo ""

# ==============================================================================
# GATHER INFO
# ==============================================================================

title "Tell me about your machine"
echo ""

USERNAME=$(ask "Your Linux username (e.g. alice)"        "youruser")
HOSTNAME=$(ask "Your machine hostname (e.g. nixbox)"     "YourHostname")
FULLNAME=$(ask "Your full name (for git config)"         "Your Name")
EMAIL=$(ask    "Your email (for git config)"             "your@email.com")
TIMEZONE=$(ask "Your timezone (e.g. Europe/London)"      "Europe/London")

echo ""
gum style --foreground 245 "  Common locales: en_GB.UTF-8 · en_US.UTF-8 · de_DE.UTF-8 · fr_FR.UTF-8"
echo ""
LOCALE=$(ask   "Your locale"                                 "en_US.UTF-8")

echo ""
gum style --foreground 245 "  Keyboard layout codes: us · gb · de · fr · es · it · pt · ru"
echo ""
KEYMAP=$(ask "Your keyboard layout code" "us")

# ==============================================================================
# CHOOSE DESKTOP ENVIRONMENT
# ==============================================================================

echo ""
title "Choose a desktop environment"
echo ""
gum style --foreground 245 "  Not sure? KDE Plasma is the most familiar if you're coming from Windows."
echo ""

DE=$(gum choose \
    "KDE Plasma 6 (recommended)" \
    "GNOME" \
    "None — I'll configure my own WM")

echo ""
success "Selected: $DE"

# ==============================================================================
# CONFIRM
# ==============================================================================

echo ""
title "About to make these changes:"
echo ""
gum style --border normal --padding "0 2" \
    "  youruser        →  $USERNAME" \
    "  YourHostname    →  $HOSTNAME" \
    "  Your Name       →  $FULLNAME" \
    "  your@email.com  →  $EMAIL" \
    "  Timezone        →  $TIMEZONE" \
    "  Locale          →  $LOCALE" \
    "  Keyboard        →  $KEYMAP" \
    "  Desktop         →  $DE"
echo ""

if ! confirm "Looks good? Continue?"; then
    warn "Aborted. No changes made."
    exit 0
fi

echo ""

# ==============================================================================
# RENAME FILES AND DIRECTORIES
# ==============================================================================

title "Renaming files and directories..."
echo ""

if [[ -f "$REPO_DIR/home/youruser.nix" ]]; then
    mv "$REPO_DIR/home/youruser.nix" "$REPO_DIR/home/${USERNAME}.nix"
    success "home/youruser.nix  →  home/${USERNAME}.nix"
fi

if [[ -d "$REPO_DIR/system/hosts/YourHostname" ]]; then
    mv "$REPO_DIR/system/hosts/YourHostname" "$REPO_DIR/system/hosts/${HOSTNAME}"
    success "system/hosts/YourHostname/  →  system/hosts/${HOSTNAME}/"
else
    warn "Could not find system/hosts/YourHostname/ — skipping directory rename."
    warn "If your folder is named differently, rename it manually."
fi

# ==============================================================================
# FIND AND REPLACE IN FILES
# ==============================================================================

title "Updating file contents..."
echo ""

CONFIG_NIX="$REPO_DIR/system/hosts/${HOSTNAME}/configuration.nix"

FILES=(
    "$REPO_DIR/flake.nix"
    "$REPO_DIR/scripts/rebuild"
    "$REPO_DIR/home/${USERNAME}.nix"
    "$REPO_DIR/home/common.nix"
    "$CONFIG_NIX"
)

do_replace() {
    local file="$1" from="$2" to="$3"
    if [[ -f "$file" ]] && grep -qF "$from" "$file"; then
        sed -i "s|${from}|${to}|g" "$file"
    fi
}

for f in "${FILES[@]}"; do
    [[ -f "$f" ]] || { warn "Not found, skipping: ${f#$REPO_DIR/}"; continue; }

    do_replace "$f" "youruser"       "$USERNAME"
    do_replace "$f" "YourHostname"   "$HOSTNAME"
    do_replace "$f" "Your Name"      "$FULLNAME"
    do_replace "$f" "your@email.com" "$EMAIL"
    do_replace "$f" "Europe/London"  "$TIMEZONE"
    do_replace "$f" "en_GB.UTF-8"    "$LOCALE"

    success "Updated: ${f#$REPO_DIR/}"
done

# ==============================================================================
# KEYBOARD LAYOUT
# ==============================================================================
# configuration.nix has two separate keyboard settings:
#   xkb.layout  — X11/Wayland layout code (e.g. "gb", "us", "de")
#   console.keyMap — TTY keymap name, which sometimes differs:
#     gb layout → "uk" keymap   (the one special case worth handling)
#     everything else → same code for both
# ==============================================================================

echo ""
title "Setting keyboard layout..."
echo ""

if [[ -f "$CONFIG_NIX" ]]; then
    # Decide the console keymap
    if [[ "$KEYMAP" == "gb" ]]; then
        CONSOLE_KEYMAP="uk"
    else
        CONSOLE_KEYMAP="$KEYMAP"
    fi

    python3 - "$CONFIG_NIX" "$KEYMAP" "$CONSOLE_KEYMAP" <<'PYEOF'
import sys, re

path, xkb_layout, console_keymap = sys.argv[1], sys.argv[2], sys.argv[3]
text = open(path).read()

# Replace xkb layout (inside the services.xserver.xkb block)
text = re.sub(r'(xkb\s*=\s*\{[^}]*layout\s*=\s*")[^"]*(")', rf'\g<1>{xkb_layout}\2', text, flags=re.DOTALL)

# Replace console keyMap
text = re.sub(r'(console\.keyMap\s*=\s*")[^"]*(")', rf'\g<1>{console_keymap}\2', text)

open(path, 'w').write(text)
PYEOF
    success "xkb.layout = \"$KEYMAP\",  console.keyMap = \"$CONSOLE_KEYMAP\""
else
    warn "Could not find configuration.nix — keyboard layout not set"
fi

# ==============================================================================
# UNCOMMENT CHOSEN DESKTOP ENVIRONMENT
# ==============================================================================
# Uses Python to reliably uncomment the right block. Each DE section is
# bounded by its own comment header, so we only touch the chosen one.
# ==============================================================================

echo ""
title "Enabling desktop environment..."
echo ""

if [[ -f "$CONFIG_NIX" ]]; then
    case "$DE" in

        "KDE Plasma 6 (recommended)")
            python3 - "$CONFIG_NIX" <<'PYEOF'
import re, sys

path = sys.argv[1]
text = open(path).read()

# Match the KDE block: from its header comment up to (not including) the next header
kde_block_re = re.compile(
    r'([ \t]*# --- KDE Plasma 6.*?)'   # KDE header
    r'(?=[ \t]*# --- )',                # stop before the next header
    re.DOTALL
)

def uncomment_kde(m):
    block = m.group(1)
    # Remove the leading '#' and one space from each commented-out line
    block = re.sub(r'^([ \t]*)# (services\.|  enable|  wayland)', r'\1\2', block, flags=re.MULTILINE)
    return block

text = kde_block_re.sub(uncomment_kde, text)
open(path, 'w').write(text)
PYEOF
            success "KDE Plasma 6 enabled"
            ;;

        "GNOME")
            python3 - "$CONFIG_NIX" <<'PYEOF'
import re, sys

path = sys.argv[1]
text = open(path).read()

gnome_block_re = re.compile(
    r'([ \t]*# --- GNOME.*?)'
    r'(?=[ \t]*# --- )',
    re.DOTALL
)

def uncomment_gnome(m):
    block = m.group(1)
    block = re.sub(r'^([ \t]*)# (services\.)', r'\1\2', block, flags=re.MULTILINE)
    return block

text = gnome_block_re.sub(uncomment_gnome, text)
open(path, 'w').write(text)
PYEOF
            success "GNOME enabled"
            ;;

        "None — I'll configure my own WM")
            success "No DE enabled — all blocks left commented out"
            info "Edit system/hosts/${HOSTNAME}/configuration.nix to configure your WM"
            ;;
    esac
else
    warn "Could not find configuration.nix — DE not configured automatically"
    warn "Edit system/hosts/${HOSTNAME}/configuration.nix manually"
fi

# ==============================================================================
# HARDWARE CONFIG
# ==============================================================================

echo ""
title "Hardware configuration..."
echo ""

HARDWARE_SRC="/etc/nixos/hardware-configuration.nix"
HARDWARE_DST="$REPO_DIR/system/hosts/${HOSTNAME}/hardware-configuration.nix"

if [[ -f "$HARDWARE_SRC" ]]; then
    cp "$HARDWARE_SRC" "$HARDWARE_DST"
    success "Copied hardware-configuration.nix from /etc/nixos/"
else
    warn "Could not find /etc/nixos/hardware-configuration.nix"
    info  "Copy it manually when you have it:"
    info  "  cp /etc/nixos/hardware-configuration.nix $HARDWARE_DST"
fi

# ==============================================================================
# MAKE SCRIPTS EXECUTABLE
# ==============================================================================

echo ""
title "Making scripts executable..."
echo ""

chmod +x "$REPO_DIR/scripts/rebuild" "$REPO_DIR/scripts/maintain" 2>/dev/null \
    && success "scripts/rebuild and scripts/maintain are now executable" \
    || warn "Could not chmod scripts — run: chmod +x ~/Settings/scripts/rebuild ~/Settings/scripts/maintain"

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
        success "Initialised git repo"
    fi

    git add -A
    git commit -m "Initial config: ${USERNAME}@${HOSTNAME}"
    success "Created initial commit"

    if [[ -n "$REMOTE" && "$REMOTE" != "skip" ]]; then
        git remote add origin "$REMOTE" 2>/dev/null \
            || git remote set-url origin "$REMOTE"
        git branch -M main
        git push -u origin main
        success "Pushed to $REMOTE"
    else
        warn "No remote set — run 'git remote add origin <url>' when ready"
    fi
fi

# ==============================================================================
# DONE
# ==============================================================================

echo ""
gum style \
    --border rounded \
    --border-foreground 2 \
    --padding "1 4" \
    --bold \
    "  Setup complete!  "
echo ""
info "Next steps:"
echo ""

if [[ "$DE" == "None — I'll configure my own WM" ]]; then
    gum style --padding "0 2" \
        "1.  Configure your WM in system/hosts/${HOSTNAME}/configuration.nix" \
        "" \
        "2.  Build your system:" \
        "      cd ~/Settings && rebuild" \
        "" \
        "3.  Reboot and enjoy."
else
    gum style --padding "0 2" \
        "1.  Build your system:" \
        "      cd ~/Settings && rebuild" \
        "" \
        "2.  Reboot and log in to ${DE%%(*}" \
        "" \
        "3.  Tweak to your heart's content."
fi
echo ""
