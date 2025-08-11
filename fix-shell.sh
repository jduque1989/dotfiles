#!/bin/bash
# Quick fix script for shell configuration

echo "🔧 Fixing shell configuration..."

# Backup current configurations
cp ~/.zshrc ~/.zshrc.backup.$(date +%Y%m%d_%H%M%S)
echo "✅ Backed up ~/.zshrc"

# Create a minimal working .zshrc that prioritizes ZIM
cat > ~/.zshrc << 'EOF'
# Start configuration added by Zim install {{{
#
# User configuration sourced by interactive shells
#

# Skip system compinit to avoid double initialization with ZIM
skip_global_compinit=1

# Early environment setup to prevent completion conflicts
export DISABLE_COMPFIX=true
export ZSH_DISABLE_COMPFIX=true

# -----------------
# Zsh configuration
# -----------------

#
# History
#

# Remove older command from the history if a duplicate is to be added.
setopt HIST_IGNORE_ALL_DUPS

#
# Input/output
#

# Set editor default keymap to emacs (`-e`) or vi (`-v`)
bindkey -e

# Prompt for spelling correction of commands.
#setopt CORRECT

# Customize spelling correction prompt.
#SPROMPT='zsh: correct %F{red}%R%f to %F{green}%r%f [nyae]? '

# Remove path separator from WORDCHARS.
WORDCHARS=${WORDCHARS//[\/]}

# -----------------
# Zim configuration
# -----------------

# Use degit instead of git as the default tool to install and update modules.
#zstyle ':zim:zmodule' use 'degit'

# --------------------
# Module configuration
# --------------------

#
# git
#

# Set a custom prefix for the generated aliases. The default prefix is 'G'.
#zstyle ':zim:git' aliases-prefix 'g'

#
# input
#

# Append `../` to your input for each `.` you type after an initial `..`
#zstyle ':zim:input' double-dot-expand yes

#
# termtitle
#

# Set a custom terminal title format using prompt expansion escape sequences.
# See http://zsh.sourceforge.net/Doc/Release/Prompt-Expansion.html#Simple-Prompt-Escapes
# If none is provided, the default '%n@%m: %~' is used.
#zstyle ':zim:termtitle' format '%1~'

#
# zsh-autosuggestions
#

# Disable automatic widget re-binding on each precmd. This can be set when
# zsh-users/zsh-autosuggestions is the last module in your ~/.zimrc.
ZSH_AUTOSUGGEST_MANUAL_REBIND=1

# Customize the style that the suggestions are shown with.
# See https://github.com/zsh-users/zsh-autosuggestions/blob/master/README.md#suggestion-highlight-style
#ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=242'

#
# zsh-syntax-highlighting
#

# Set what highlighters will be used.
# See https://github.com/zsh-users/zsh-syntax-highlighting/blob/master/docs/highlighters.md
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets)

# Customize the main highlighter styles.
# See https://github.com/zsh-users/zsh-syntax-highlighting/blob/master/docs/highlighters/main.md#how-to-tweak-it
#typeset -A ZSH_HIGHLIGHT_STYLES
#ZSH_HIGHLIGHT_STYLES[comment]='fg=242'

# ------------------
# Initialize modules
# ------------------

ZIM_HOME=${ZDOTDIR:-${HOME}}/.zim
# Download zimfw plugin manager if missing.
if [[ ! -e ${ZIM_HOME}/zimfw.zsh ]]; then
  if (( ${+commands[curl]} )); then
    curl -fsSL --create-dirs -o ${ZIM_HOME}/zimfw.zsh \
        https://github.com/zimfw/zimfw/releases/latest/download/zimfw.zsh
  else
    mkdir -p ${ZIM_HOME} && wget -nv -O ${ZIM_HOME}/zimfw.zsh \
        https://github.com/zimfw/zimfw/releases/latest/download/zimfw.zsh
  fi
fi
# Install missing modules, and update ${ZIM_HOME}/init.zsh if missing or outdated.
if [[ ! ${ZIM_HOME}/init.zsh -nt ${ZIM_CONFIG_FILE:-${ZDOTDIR:-${HOME}}/.zimrc} ]]; then
  source ${ZIM_HOME}/zimfw.zsh init
fi
# Initialize modules.
source ${ZIM_HOME}/init.zsh

# ------------------------------
# Post-init module configuration
# ------------------------------

#
# zsh-history-substring-search
#

zmodload -F zsh/terminfo +p:terminfo
# Bind ^[[A/^[[B manually so up/down works both before and after zle-line-init
for key ('^[[A' '^P' ${terminfo[kcuu1]}) bindkey ${key} history-substring-search-up
for key ('^[[B' '^N' ${terminfo[kcud1]}) bindkey ${key} history-substring-search-down
for key ('k') bindkey -M vicmd ${key} history-substring-search-up
for key ('j') bindkey -M vicmd ${key} history-substring-search-down
unset key
# }}} End configuration added by Zim install

# Set ZIM_HOME if not set
export ZIM_HOME="${ZIM_HOME:-${HOME}/.zim}"
export OPENAI_API_KEY="$(security find-generic-password -s OPENAI_API_KEY -w 2>/dev/null || true)"

# Load zsh-defer if available
if [[ -f ~/zsh-defer/zsh-defer.plugin.zsh ]]; then
    source ~/zsh-defer/zsh-defer.plugin.zsh
fi

# Load custom modules AFTER ZIM initialization
if [[ -f ~/.config/.zsh/modules/core.zsh ]]; then
    source ~/.config/.zsh/modules/core.zsh
fi

if [[ -f ~/.config/.zsh/modules/aliases.zsh ]]; then
    source ~/.config/.zsh/modules/aliases.zsh
fi

if [[ -f ~/.config/.zsh/modules/functions.zsh ]]; then
    source ~/.config/.zsh/modules/functions.zsh
fi

if [[ -f ~/.config/.zsh/modules/prompt.zsh ]]; then
    source ~/.config/.zsh/modules/prompt.zsh
fi

# Environment variables
export PATH="$HOME/.pyenv/bin:$HOME/Library/Application Support/reflex/bun/bin:/opt/homebrew/opt/llvm/bin:$HOME/.npm-global/bin:./.venv/bin:$PATH"
export RX_NODE_PATH=$(which node)

# Defer heavy tools for better startup performance (if zsh-defer is available)
if command -v zsh-defer >/dev/null 2>&1; then
    zsh-defer 'sleep 0.5 && eval "$(pyenv init --path)" 2>/dev/null &!'
    zsh-defer 'sleep 0.5 && eval "$(pyenv init -)" 2>/dev/null &!'
    zsh-defer 'eval "$(zoxide init --cmd cd zsh)" 2>/dev/null'
    zsh-defer '[ -f ~/.env ] && set -a && source ~/.env && set +a'
    
    # Prompt: Starship (only for non-Warp terminals, deferred to avoid conflicts)
    if [[ "$TERM_PROGRAM" != "WarpTerminal" ]]; then
        zsh-defer 'eval "$(starship init zsh)" 2>/dev/null'
    fi
fi

# Completion cache config
zstyle ':completion::complete:*' use-cache on
zstyle ':completion::complete:*' cache-path ~/.zsh/cache
EOF

echo "✅ Created clean ~/.zshrc"

# Fix the .config/.zshrc to not conflict
if [[ -f ~/.config/.zshrc ]]; then
    mv ~/.config/.zshrc ~/.config/.zshrc.disabled
    echo "✅ Disabled conflicting ~/.config/.zshrc"
fi

echo "🎉 Shell configuration fixed!"
echo "📝 Run 'source ~/.zshrc' or restart your terminal to apply changes"
echo "💡 Your old config was backed up to ~/.zshrc.backup.*"