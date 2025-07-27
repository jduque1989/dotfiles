#!/bin/bash

# Migration script from Homebrew to Nix
# This script helps migrate packages while keeping Homebrew as backup

set -e

echo "🍎 macOS Nix Migration Script"
echo "=============================="

# Check if running on macOS
if [[ "$OSTYPE" != "darwin"* ]]; then
    echo "❌ This script is for macOS only"
    exit 1
fi

# Backup current Homebrew package list
echo "📦 Backing up current Homebrew packages..."
if command -v brew &> /dev/null; then
    mkdir -p ~/.dotfiles-backup
    brew list --formula > ~/.dotfiles-backup/homebrew-formulas.txt
    brew list --cask > ~/.dotfiles-backup/homebrew-casks.txt
    echo "✅ Homebrew packages backed up to ~/.dotfiles-backup/"
else
    echo "ℹ️  Homebrew not found, skipping backup"
fi

# Install nix-darwin
echo "🏗️  Installing nix-darwin..."
if ! command -v darwin-rebuild &> /dev/null; then
    echo "Installing nix-darwin..."
    sudo nix --extra-experimental-features nix-command --extra-experimental-features flakes run nix-darwin -- switch --flake ~/dotfiles#simple
else
    echo "✅ nix-darwin already installed"
fi

# Apply the flake configuration
echo "🔧 Applying Nix flake configuration..."
cd ~/dotfiles
sudo darwin-rebuild switch --flake .#simple

echo "✅ Nix configuration applied!"

# Instructions for user
echo ""
echo "🎉 Migration Steps Completed!"
echo "=========================="
echo ""
echo "Next steps:"
echo "1. Restart your terminal or run: exec zsh"
echo "2. Test that Nix packages work: eza --version"
echo "3. If everything works, you can optionally remove Homebrew packages:"
echo "   brew uninstall <package-name>"
echo ""
echo "Your Homebrew packages are backed up in ~/.dotfiles-backup/"
echo "You can keep both package managers if needed."