#!/usr/bin/env bash
set -e

echo "🧪 Minimal setup test..."

ln -sfv "$(pwd)/.zshrc" "$HOME/.zshrc"
ln -sfv "$(pwd)/.zshenv" "$HOME/.zshenv"

echo "✅ Minimal setup complete"
