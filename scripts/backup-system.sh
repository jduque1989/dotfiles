#!/bin/bash

# System backup script for dotfiles and package states
# Ensures you can always rollback to a working state

set -e

BACKUP_DIR="$HOME/.dotfiles-backup/$(date +%Y%m%d-%H%M%S)"

echo "🔄 Creating system backup..."
echo "Backup location: $BACKUP_DIR"

# Create backup directory
mkdir -p "$BACKUP_DIR"

# Backup Homebrew state (if installed)
if command -v brew &> /dev/null; then
    echo "📦 Backing up Homebrew packages..."
    brew list --formula > "$BACKUP_DIR/homebrew-formulas.txt" 2>/dev/null || echo "No formulas found"
    brew list --cask > "$BACKUP_DIR/homebrew-casks.txt" 2>/dev/null || echo "No casks found"
    brew leaves > "$BACKUP_DIR/homebrew-leaves.txt" 2>/dev/null || echo "No leaves found"
fi

# Backup Nix profile state (if installed)
if command -v nix &> /dev/null; then
    echo "❄️  Backing up Nix profile..."
    nix profile list > "$BACKUP_DIR/nix-profile.txt" 2>/dev/null || echo "No Nix profile found"
fi

# Backup current dotfiles
echo "📋 Backing up current dotfiles..."
rsync -av --exclude='.git' "$HOME/dotfiles/" "$BACKUP_DIR/dotfiles/" 2>/dev/null || true

# Backup shell configuration
echo "🐚 Backing up shell configuration..."
cp "$HOME/.zshrc" "$BACKUP_DIR/zshrc.backup" 2>/dev/null || true
cp -r "$HOME/.config" "$BACKUP_DIR/config-backup/" 2>/dev/null || true

# Create restore script
cat > "$BACKUP_DIR/restore.sh" << 'EOF'
#!/bin/bash
# Restore script generated automatically

BACKUP_DIR="$(dirname "$0")"

echo "🔄 Restoring from backup: $BACKUP_DIR"

# Restore dotfiles
if [ -d "$BACKUP_DIR/dotfiles" ]; then
    echo "📋 Restoring dotfiles..."
    rsync -av "$BACKUP_DIR/dotfiles/" "$HOME/dotfiles/"
fi

# Restore shell config
if [ -f "$BACKUP_DIR/zshrc.backup" ]; then
    echo "🐚 Restoring .zshrc..."
    cp "$BACKUP_DIR/zshrc.backup" "$HOME/.zshrc"
fi

if [ -d "$BACKUP_DIR/config-backup" ]; then
    echo "⚙️  Restoring .config..."
    cp -r "$BACKUP_DIR/config-backup" "$HOME/.config"
fi

echo "✅ Restore completed! Restart your terminal."
EOF

chmod +x "$BACKUP_DIR/restore.sh"

echo "✅ Backup completed!"
echo "📁 Backup location: $BACKUP_DIR"
echo "🔄 To restore: $BACKUP_DIR/restore.sh"