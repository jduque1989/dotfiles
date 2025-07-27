#!/bin/bash

# Nix-specific rollback script
# Provides easy rollback functionality for Nix-darwin changes

set -e

echo "❄️  Nix-darwin Rollback Utility"
echo "==============================="

# Show current generations
echo "📜 Available generations:"
nix-env --list-generations -p /nix/var/nix/profiles/system

echo ""
echo "🔄 Recent darwin-rebuild generations:"
ls -la /nix/var/nix/profiles/system-*-link 2>/dev/null | tail -5 || echo "No system profiles found"

echo ""
read -p "Do you want to rollback to the previous generation? (y/N): " confirm

if [[ $confirm =~ ^[Yy]$ ]]; then
    echo "🔄 Rolling back..."
    darwin-rebuild rollback
    echo "✅ Rollback completed! Your system has been reverted."
    echo "🔄 Please restart your terminal or run: exec zsh"
else
    echo "ℹ️  Rollback cancelled."
    echo ""
    echo "💡 Available commands:"
    echo "   darwin-rebuild rollback              # Quick rollback"
    echo "   darwin-rebuild switch --rollback    # Rollback and switch"
    echo "   nix-env --rollback -p /nix/var/nix/profiles/system  # Manual rollback"
fi