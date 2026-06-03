# ==============================================================================
# HARDWARE-CONFIGURATION.NIX — placeholder
# ==============================================================================
# This file is gitignored and must be replaced before building.
#
# Either run setup.sh (it copies /etc/nixos/hardware-configuration.nix here
# automatically), or copy it manually:
#
#   cp /etc/nixos/hardware-configuration.nix \
#      ~/Settings/system/hosts/<YourHostname>/hardware-configuration.nix
# ==============================================================================

{ ... }:

builtins.throw ''
  hardware-configuration.nix has not been set up yet.

  Run setup.sh, or copy your hardware config manually:
    cp /etc/nixos/hardware-configuration.nix \
       ~/Settings/system/hosts/<YourHostname>/hardware-configuration.nix
''
