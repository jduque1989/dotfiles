#!/usr/bin/env bash
set -e

echo "🔧 Starting dotfiles setup..."

# Symlink top-level dotfiles to home
echo "🔗 Symlinking dotfiles..."
DOTFILES_DIR="$(pwd)"
FILES_TO_SYMLINK=(".zshrc" ".zshenv" ".bashrc" ".gitconfig")

for file in "${FILES_TO_SYMLINK[@]}"; do
    ln -sfv "$DOTFILES_DIR/$file" "$HOME/$file"
done

# Symlink .config contents (if you have Neovim, tmux, etc.)
echo "📁 Linking .config files..."
mkdir -p "$HOME/.config"
cp -rT "$DOTFILES_DIR/.config" "$HOME/.config"

# Set Zsh as default shell
if command -v zsh &>/dev/null; then
    echo "💻 Setting default shell to Zsh..."
    chsh -s "$(which zsh)" || true
fi

echo "✅ Dotfiles setup complete!"
