# ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
# ┃                                        🚀 Core ZSH Module                                       ┃
# ┃                                  Essential Shell Configuration                                   ┃
# ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

# ─────────────────────────────────────────────────────────────────────────────────────────────────
# EDITOR & KEYBINDINGS
# ─────────────────────────────────────────────────────────────────────────────────────────────────

export EDITOR="nvim"
export VISUAL="nvim"
export PAGER="less"

# Use emacs key bindings
bindkey -e

# ─────────────────────────────────────────────────────────────────────────────────────────────────
# HISTORY CONFIGURATION
# ─────────────────────────────────────────────────────────────────────────────────────────────────

HISTFILE="${ZDOTDIR:-$HOME}/.zsh_history"
HISTSIZE=50000
SAVEHIST=50000

# History options
setopt EXTENDED_HISTORY          # Record timestamp in history
setopt HIST_EXPIRE_DUPS_FIRST   # Expire duplicate entries first
setopt HIST_IGNORE_DUPS         # Don't record an entry that was just recorded again
setopt HIST_IGNORE_ALL_DUPS     # Delete old recorded entry if new entry is a duplicate
setopt HIST_FIND_NO_DUPS        # Don't display a line previously found
setopt HIST_IGNORE_SPACE        # Don't record an entry starting with a space
setopt HIST_SAVE_NO_DUPS        # Don't write duplicate entries in the history file
setopt HIST_REDUCE_BLANKS       # Remove superfluous blanks before recording entry
setopt HIST_VERIFY              # Don't execute immediately upon history expansion
setopt SHARE_HISTORY            # Share history between all sessions

# ─────────────────────────────────────────────────────────────────────────────────────────────────
# DIRECTORY NAVIGATION
# ─────────────────────────────────────────────────────────────────────────────────────────────────

setopt AUTO_CD                  # Auto cd to directory if typed as command
setopt AUTO_PUSHD               # Push directories to stack automatically
setopt PUSHD_IGNORE_DUPS        # Don't push multiple copies of the same directory onto the directory stack
setopt PUSHD_MINUS              # This should make cd +N go to the Nth directory in the stack

# ─────────────────────────────────────────────────────────────────────────────────────────────────
# COMPLETION SETTINGS
# ─────────────────────────────────────────────────────────────────────────────────────────────────

setopt COMPLETE_IN_WORD         # Complete from both ends of a word
setopt ALWAYS_TO_END            # Move cursor to the end of a completed word
setopt PATH_DIRS                # Perform path search even on command names with slashes
setopt AUTO_MENU                # Show completion menu on successive tab press
setopt AUTO_LIST                # Automatically list choices on ambiguous completion
setopt AUTO_PARAM_SLASH         # If completed parameter is a directory, add a trailing slash
setopt EXTENDED_GLOB            # Needed for file modification glob modifiers with compinit
unsetopt MENU_COMPLETE          # Don't autoselect the first completion entry
unsetopt FLOW_CONTROL           # Disable start/stop characters in shell editor

# ─────────────────────────────────────────────────────────────────────────────────────────────────
# PATH MANAGEMENT
# ─────────────────────────────────────────────────────────────────────────────────────────────────

# Remove duplicates from PATH
typeset -U path PATH

# Essential paths
path=(
    ~/.local/bin
    ~/.npm-global/bin
    ~/.cargo/bin
    /opt/homebrew/bin
    /opt/homebrew/sbin
    /usr/local/bin
    /usr/bin
    /bin
    /usr/sbin
    /sbin
    $path
)

# ─────────────────────────────────────────────────────────────────────────────────────────────────
# ENVIRONMENT VARIABLES
# ─────────────────────────────────────────────────────────────────────────────────────────────────

# Language
export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"

# Less options
export LESS="-R -S -M -i -j4 -F -X"

# Colors for ls and other commands
export CLICOLOR=1
export LSCOLORS="ExFxCxDxBxegedabagacad"

# Node.js
export NODE_REPL_HISTORY_SIZE=10000

# Python
export PYTHONIOENCODING="utf-8"
export PYTHONUNBUFFERED=1

# ─────────────────────────────────────────────────────────────────────────────────────────────────
# MISC SETTINGS
# ─────────────────────────────────────────────────────────────────────────────────────────────────

# Don't beep
unsetopt BEEP

# Allow comments in interactive shell
setopt INTERACTIVE_COMMENTS

# Don't kill background jobs on shell exit
setopt NO_HUP
setopt NO_CHECK_JOBS