# Niri Rice Styling Guide 🎨

I've created 4 different aesthetic configs for you to try:

## 🌆 Cyberpunk (`cyberpunk.kdl`)
**Vibe**: Neon lights, hot pink and cyan, dramatic
- Thick borders (3px) with pink-to-cyan gradient
- Bigger gaps (24px) for that "floating in cyberspace" feel
- More transparent inactive windows (0.75 opacity)
- Slower, more dramatic animations (350ms window open)
- **Best for**: Late night coding sessions, feeling like a hacker

## 🧘 Zen Minimalist (`zen.kdl`)
**Vibe**: Clean, focused, Japanese minimalism
- Thin borders (1px) that barely intrude
- Generous spacing (32px gaps)
- Uses golden ratio (0.618) for window proportions
- Subtle animations (180ms)
- Soft, barely-there transparency (0.92)
- **Best for**: Deep work, reading, writing, meditation

## 🌴 Vaporwave (`vaporwave.kdl`)
**Vibe**: 80s nostalgia, pink and purple pastels, chunky
- THICC borders (4px) for retro feel
- Sharp corners (0 radius) - no rounding
- Pink-to-cyan gradient borders
- Bouncy, overshooting animations ("ease-out-back")
- **Best for**: Feeling aesthetic, music production, vibing

## ❄️ Arctic Nord (`nord.kdl`)
**Vibe**: Professional, cool tones, northern lights
- Medium borders (2px) with frost blue gradient
- Balanced spacing (18px)
- Professional frost blue color scheme
- Smooth, ice-like animations
- **Best for**: Work, presentations, looking professional

---

## How to Try Them

1. **Backup your current config**:
```bash
cp ~/.config/niri/config.kdl ~/.config/niri/config.kdl.backup
```

2. **Copy a new theme**:
```bash
cp /path/to/cyberpunk.kdl ~/.config/niri/config.kdl
```

3. **Reload niri**:
```bash
# Press Mod+Shift+R
# Or manually:
niri-msg action reload-config
```

4. **Try them all!** Switch between them to see which aesthetic speaks to you.

---

## Customization Tips

### Color Schemes
Change the border colors to match your taste:

```kdl
border {
    active-color "#YOUR_HEX_COLOR"
    inactive-color "#YOUR_HEX_COLOR"
    
    // Or use gradients!
    active-gradient from="#COLOR1" to="#COLOR2" angle=45
}
```

**Popular color palettes**:
- **Dracula**: `#bd93f9` (purple) and `#ff79c6` (pink)
- **Gruvbox**: `#fb4934` (red) and `#b8bb26` (green)
- **Catppuccin Mocha**: `#89b4fa` (blue) and `#f5c2e7` (pink)
- **Everforest**: `#a7c080` (green) and `#d699b6` (pink)

### Gap Sizes
```kdl
layout {
    gaps 16   // Compact
    gaps 24   // Comfortable (default)
    gaps 32   // Spacious
    gaps 48   // Maximum chill
}
```

### Border Thickness
```kdl
border {
    width 1   // Minimal
    width 2   // Balanced
    width 3   // Noticeable
    width 4   // Chunky retro
    width 6   // EXTREME
}
```

### Corner Rounding
```kdl
window-rule {
    geometry-corner-radius 0    // Sharp (retro)
    geometry-corner-radius 8    // Subtle
    geometry-corner-radius 12   // Rounded (default)
    geometry-corner-radius 16   // Very rounded
    geometry-corner-radius 24   // Pill-shaped
}
```

### Transparency
```kdl
window-rule {
    match is-active=false
    opacity 0.70  // Very transparent
    opacity 0.85  // Noticeable (default)
    opacity 0.95  // Subtle
    opacity 1.0   // Opaque
}
```

### Animation Speed
```kdl
animations {
    window-open {
        duration-ms 150   // Snappy
        duration-ms 250   // Balanced
        duration-ms 400   // Theatrical
        duration-ms 600   // Slooow
    }
}
```

### Animation Curves
Try different curves for different feels:
- `"ease-out-cubic"` - Smooth and natural
- `"ease-out-expo"` - Aggressive slowdown
- `"ease-out-back"` - Overshoots and bounces back
- `"ease-in-out-quad"` - Symmetrical acceleration

---

## Mix and Match!

Don't like the whole theme? Mix elements:

**Example - "Cyberpunk colors with Zen spacing"**:
```kdl
layout {
    gaps 32  // Zen spacing
    border {
        width 3
        active-gradient from="#ff007c" to="#00d9ff" angle=45  // Cyberpunk colors
    }
}
```

---

## Matching Waybar, Rofi, and Alacritty

To make your whole system match, you'll need to theme:

### Waybar
Edit `~/.config/waybar/style.css`:
```css
/* Cyberpunk example */
* {
    border: none;
    font-family: "FiraCode Nerd Font";
}

window#waybar {
    background: rgba(10, 14, 39, 0.9);
    border-bottom: 3px solid #ff007c;
}

#workspaces button.active {
    background: linear-gradient(90deg, #ff007c 0%, #00d9ff 100%);
}
```

### Rofi
Edit `~/.config/rofi/config.rasi`:
```css
* {
    background-color: #0a0e27;
    border-color: #ff007c;
    accent: #00d9ff;
}
```

### Alacritty
Edit `~/.config/alacritty/alacritty.toml`:
```toml
[colors.primary]
background = "#0a0e27"
foreground = "#c0caf5"

[colors.normal]
cyan = "#00d9ff"
magenta = "#ff007c"
```

---

## My Recommendation

Start with **Cyberpunk** if you want to feel the difference immediately. It's the most dramatic change from your current config.

Then try **Zen** for a completely opposite vibe - see which direction you like more.

Then customize from there! Take bits from each that you like.

**Pro tip**: Keep 2-3 configs saved with different names:
```bash
~/.config/niri/config-cyberpunk.kdl
~/.config/niri/config-zen.kdl
~/.config/niri/config.kdl  # Your active one
```

Then you can switch between them easily:
```bash
cp ~/.config/niri/config-cyberpunk.kdl ~/.config/niri/config.kdl && niri-msg action reload-config
```

---

## Questions?

Want me to:
- Create a specific color scheme?
- Mix elements from multiple themes?
- Generate matching Waybar/Rofi/Alacritty configs?
- Make something completely wild?

Just ask!
