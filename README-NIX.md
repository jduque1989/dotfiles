# Nix Configuration for macOS

This repository now includes a complete Nix setup for macOS package management using `nix-darwin` and `home-manager`.

## Quick Start

1. **Apply the Nix configuration:**
   ```bash
   ./scripts/migrate-to-nix.sh
   ```

2. **Restart your terminal** or run:
   ```bash
   exec zsh
   ```

## Files Structure

```
dotfiles/
├── flake.nix                    # Main Nix flake configuration
├── nix/
│   ├── modules/
│   │   └── home.nix            # Home Manager configuration
│   └── packages/
│       └── default.nix        # Custom packages
└── scripts/
    ├── migrate-to-nix.sh       # Migration script
    ├── backup-system.sh        # System backup utility
    └── nix-rollback.sh         # Rollback utility
```

## Daily Usage

### Package Management

```bash
# Update system and packages
nix-update

# Search for packages
nix-search firefox

# Temporarily use a package
nix-shell-run python3 python --version

# List installed packages
nix-list
```

### Configuration Management

```bash
# Edit main Nix config
nix-config

# Edit Home Manager config  
nix-home-config

# Apply changes after editing
nix-update
```

### Safety & Rollbacks

```bash
# Create system backup
./scripts/backup-system.sh

# Rollback to previous generation
nix-rollback
# or
./scripts/nix-rollback.sh
```

## Installed Packages

The configuration includes modern CLI tools:

- **File Operations**: `eza`, `bat`, `fd`, `ripgrep`, `fzf`
- **Development**: `neovim`, `git`, `tmux`, `gh`
- **Languages**: `nodejs`, `python3`, `rustc`
- **System**: `htop`, `btop`, `tree`, `curl`, `wget`

## Customization

### Adding Packages

1. Edit `flake.nix` to add system packages
2. Edit `nix/modules/home.nix` to add user packages
3. Run `nix-update` to apply changes

### Custom Packages

Add custom derivations to `nix/packages/default.nix`.

## Migration Notes

- **Homebrew Coexistence**: The configuration allows Homebrew and Nix to coexist
- **PATH Priority**: Nix packages take priority over Homebrew in PATH
- **Backups**: Your original Homebrew package lists are saved in `~/.dotfiles-backup/`

## Troubleshooting

### Common Issues

1. **Command not found**: Restart terminal or run `exec zsh`
2. **Permission issues**: Ensure `/nix` permissions are correct
3. **Flake errors**: Run `nix flake check` to validate configuration

### Emergency Rollback

If something breaks:

```bash
# Quick rollback
darwin-rebuild rollback

# Or use the backup script
~/.dotfiles-backup/YYYYMMDD-HHMMSS/restore.sh
```

## Benefits

- **Reproducible**: Same packages across machines
- **Atomic**: Updates are atomic and rollback-able  
- **Declarative**: Configuration as code
- **Fast**: Binary cache means no compilation
- **Safe**: Easy rollbacks if something breaks