#!/usr/bin/env bash
# Quick verification and fix script for Settings reorganization

echo "=========================================="
echo "Settings Reorganization Verification"
echo "=========================================="
echo ""

# Check if we're in Settings directory
if [[ ! -f "flake.nix" ]]; then
    echo "❌ Error: Not in Settings directory"
    echo "Run this from ~/Settings"
    exit 1
fi

echo "✅ In Settings directory"
echo ""

# Check for required files
echo "Checking home-manager files..."
if [[ -f "home/common.nix" ]]; then
    echo "✅ home/common.nix exists"
else
    echo "❌ home/common.nix missing"
fi

if [[ -f "home/juso.nix" ]]; then
    echo "✅ home/juso.nix exists"
else
    echo "❌ home/juso.nix missing"
fi

if [[ -f "home/darwin.nix" ]]; then
    echo "✅ home/darwin.nix exists"
else
    echo "❌ home/darwin.nix missing"
fi

echo ""

# Check flake.nix for correct import
echo "Checking flake.nix import path..."
if grep -q "import ./home/darwin.nix" flake.nix; then
    echo "✅ flake.nix has correct darwin.nix import"
elif grep -q "import ./home/juso-darwin.nix" flake.nix; then
    echo "⚠️  flake.nix still imports juso-darwin.nix"
    echo ""
    echo "Fix this by editing flake.nix line 73:"
    echo "  Change: import ./home/juso-darwin.nix;"
    echo "  To:     import ./home/darwin.nix;"
    echo ""
    read -p "Would you like me to fix this automatically? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        sed -i 's|import ./home/juso-darwin.nix|import ./home/darwin.nix|g' flake.nix
        echo "✅ Fixed flake.nix"
    fi
else
    echo "❓ Could not find darwin import in flake.nix"
fi

echo ""

# Check directory structure
echo "Checking config directory structure..."
if [[ -d "config/common" ]]; then
    echo "✅ config/common/ exists"
else
    echo "❌ config/common/ missing"
fi

if [[ -d "config/nixos" ]]; then
    echo "✅ config/nixos/ exists"
else
    echo "❌ config/nixos/ missing"
fi

if [[ -d "config/darwin" ]]; then
    echo "✅ config/darwin/ exists"
else
    echo "⚠️  config/darwin/ missing (ok if empty)"
fi

echo ""
echo "=========================================="
echo "Git Status"
echo "=========================================="
git status --short

echo ""
echo "=========================================="
echo "Next Steps"
echo "=========================================="
echo "1. If all checks pass, add files to git:"
echo "   git add -A"
echo ""
echo "2. Test the rebuild:"
echo "   ./scripts/rebuild"
echo ""
echo "3. If successful, commit:"
echo "   git commit -m 'Reorganize configs for cross-platform support'"
echo "   git push origin main"
echo ""
