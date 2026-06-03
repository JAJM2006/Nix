# Machine-specific config overrides

This folder is for config files that only apply to **one specific machine**.

Rename this folder to your hostname — the same name you used in `setup.sh`.
Then put any machine-specific config files inside it.

## The pattern

```
config/
├── common/                  ← config that applies on every machine
│   ├── alacritty/
│   ├── nvim/
│   └── starship/
│
└── nixos/
    └── your-hostname/       ← config that only applies on THIS machine
        └── (your files)
```

Config files in `config/common/` are symlinked for everyone.
Files in `config/nixos/your-hostname/` you symlink yourself in `home/youruser.nix`,
so they only land on the machine they're meant for.

## When would I use this?

- Your desktop has a big monitor and needs a larger font than your laptop
- One machine runs a different colour theme
- A work machine needs a different SSH config than your home machine
- Any setting that makes sense on one machine but not others

## Example

`alacritty-override.toml` in this folder is a worked example — open it and
read the comments. It shows exactly how to wire a machine-specific file into
the rest of the template.

## Don't need it?

If all your machines will be identical, just ignore this folder entirely.
Nothing in the template depends on it.
