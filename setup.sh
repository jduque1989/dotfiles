#!/usr/bin/env bash
set -euo pipefail

echo "🔧 Starting Zsh dotfiles setup..."

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Backup helper
backup_if_exists() {
    local target="$1"
    if [ -e "$target" ] && [ ! -L "$target" ]; then
        local backup="${target}.bak.$(date +%s)"
        echo "📦 Backing up $target to $backup"
        mv "$target" "$backup"
    fi
}

# Symlink helper
link_file() {
    local source_file="$1"
    local target_file="$2"
    if [ -f "$source_file" ]; then
        backup_if_exists "$target_file"
        ln -sfv "$source_file" "$target_file"
    fi
}

# Link Zsh config files
link_file "$DOTFILES_DIR/.zshrc" "$HOME/.zshrc"
link_file "$DOTFILES_DIR/.zshenv" "$HOME/.zshenv"
link_file "$DOTFILES_DIR/.zimrc" "$HOME/.zimrc"

# Install zsh-defer
if [ ! -d "$HOME/zsh-defer" ]; then
    echo "📦 Installing zsh-defer..."
    git clone https://github.com/romkatv/zsh-defer.git "$HOME/zsh-defer"
else
    echo "✅ zsh-defer already present"
fi

# Run zimfw install if available
if command -v zimfw >/dev/null 2>&1; then
    echo "🔄 Installing Zim modules..."
    zimfw install
else
    echo "⚠️  zimfw not found. You can install it with:"
    echo "   curl -fsSL https://raw.githubusercontent.com/zimfw/install/master/install.zsh | zsh"
fi

echo "✅ Dotfiles setup complete! Run 'exec zsh' to apply."
