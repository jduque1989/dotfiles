# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a personal dotfiles repository containing shell configurations, Neovim setup, and various application configurations for macOS development environment.

## Key Architecture Components

### ZSH Configuration System
The ZSH setup uses a modular architecture with deferred loading for performance:

- **Core Structure**: `.config/.zshrc` orchestrates module loading with immediate vs deferred priorities
- **Module System**: Located in `.config/.zsh/modules/` with specialized files:
  - `core.zsh`: Essential shell settings, history, editor config, PATH management
  - `env.zsh`: Environment variables and fixed paths  
  - `aliases.zsh`: Command shortcuts using modern tools (eza, nvim)
  - `functions.zsh`: Interactive functions using fzf for file/directory navigation
  - `prompt.zsh`: Shell prompt configuration
  - `plugins.zsh`: External plugin management
  - `fzf-config.zsh`: Fuzzy finder customization

### Dependency Management
- **ZIM Framework**: Uses `.config/.zimrc` for ZSH plugin management
- **ZSH-defer**: Performance optimization for non-critical module loading
- **Tool Dependencies**: eza, bat, fzf, fd, nvim, pyenv

### Neovim Configuration
- **Plugin Manager**: Uses lazy.nvim for plugin management
- **Architecture**: Modular Lua configuration split between `core/` and `plugins/` directories
- **Key Features**: LSP, autocompletion, treesitter, telescope, git integration

## Common Development Commands

### Shell Configuration
```bash
# Reload ZSH configuration
reload

# Edit main ZSH config
zshrc

# Quick file editing with fuzzy search
vf

# Quick directory navigation with fuzzy search  
cf
```

### Application Management
The dotfiles include configurations for:
- **Terminal**: iTerm2 custom configurations
- **File Management**: ranger with devicons plugin
- **System Monitoring**: htop, btop, neofetch configurations
- **Music**: spotify-tui and spotifyd daemon
- **File Listing**: eza (modern ls replacement)
- **VPN**: WireGuard configurations

## File Organization Patterns

### Configuration Structure
```
.config/
├── .zshrc              # Main shell entry point
├── .zimrc              # ZSH plugin declarations  
├── .zsh/modules/       # Modular shell configuration
├── nvim/               # Neovim configuration
├── [app-name]/         # Application-specific configs
```

### ZSH Module Loading Strategy
1. **Immediate Loading**: core.zsh, prompt.zsh, aliases.zsh (performance critical)
2. **Deferred Loading**: All other modules loaded with zsh-defer for shell startup speed
3. **Path Management**: Consolidated in core.zsh to avoid slow eval calls

## Environment Setup Requirements

### Essential Tools
- Homebrew (package management)
- Node.js with npm global packages
- Python with pyenv
- Rust with cargo
- Modern CLI tools: eza, bat, fzf, fd

### Path Configuration
The system expects these paths to be available:
- `~/.local/bin` (local binaries)
- `~/.npm-global/bin` (npm global packages) 
- `~/.cargo/bin` (Rust binaries)
- `/opt/homebrew/bin/node` (Node.js via Homebrew)

## Performance Considerations

The configuration prioritizes shell startup speed through:
- Deferred loading of non-essential modules
- Fixed paths instead of dynamic evaluation
- Optimized history settings with deduplication
- Lazy plugin initialization where possible