# ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
# ┃                                       🚀 Aliases Module                                        ┃
# ┃                                   Command Shortcuts & Tools                                     ┃
# ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

# ─────────────────────────────────────────────────────────────────────────────────────────────────
# MODERN CLI REPLACEMENTS
# ─────────────────────────────────────────────────────────────────────────────────────────────────

# Better ls with eza
if command -v eza >/dev/null 2>&1; then
    alias ls='eza --color=auto --group-directories-first'
    alias ll='eza -alF --color=auto --group-directories-first --git'
    alias la='eza -a --color=auto --group-directories-first'
    alias l='eza -CF --color=auto --group-directories-first'
    alias tree='eza --tree --color=auto'
else
    alias ll='ls -alF'
    alias la='ls -A'
    alias l='ls -CF'
fi

# Better cat with bat
if command -v bat >/dev/null 2>&1; then
    alias cat='bat --paging=never'
    alias ccat='bat --paging=never --plain' # colorless cat
fi

# Better grep with ripgrep
if command -v rg >/dev/null 2>&1; then
    alias grep='rg'
fi

# Better find with fd
if command -v fd >/dev/null 2>&1; then
    alias find='fd'
fi

# ─────────────────────────────────────────────────────────────────────────────────────────────────
# EDITOR SHORTCUTS
# ─────────────────────────────────────────────────────────────────────────────────────────────────

alias vim='nvim'
alias vi='nvim'
alias v='nvim'
alias e='nvim'

# Configuration files
alias zshrc='nvim ~/.zshrc'
alias vimrc='nvim ~/.config/nvim/init.lua'
alias reload='source ~/.zshrc'

# ─────────────────────────────────────────────────────────────────────────────────────────────────
# DIRECTORY NAVIGATION
# ─────────────────────────────────────────────────────────────────────────────────────────────────

alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'

alias ~='cd ~'
alias -- -='cd -'

# Create directory and cd into it
mkcd() {
    mkdir -p "$1" && cd "$1"
}

# ─────────────────────────────────────────────────────────────────────────────────────────────────
# GIT SHORTCUTS
# ─────────────────────────────────────────────────────────────────────────────────────────────────

alias g='git'
alias ga='git add'
alias gaa='git add --all'
alias gst='git status'
alias gco='git checkout'
alias gcb='git checkout -b'
alias gc='git commit -v'
alias gcm='git commit -m'
alias gp='git push'
alias gpl='git pull'
alias glog='git log --oneline --graph --decorate'
alias gd='git diff'
alias gds='git diff --staged'

# ─────────────────────────────────────────────────────────────────────────────────────────────────
# SYSTEM UTILITIES
# ─────────────────────────────────────────────────────────────────────────────────────────────────

# Process management
alias psg='ps aux | grep -v grep | grep -i -e VSZ -e'
alias psgrep='ps aux | grep -v grep | grep -i'
alias htop='sudo htop'

# Network
alias ping='ping -c 5'
alias ports='netstat -tulanp'
alias myip='curl -s https://ipecho.net/plain; echo'
alias localip='ifconfig | grep "inet " | grep -v 127.0.0.1 | awk "{print \$2}"'

# Disk usage
alias du='du -h'
alias df='df -h'
alias diskusage='df -h'

# ─────────────────────────────────────────────────────────────────────────────────────────────────
# DEVELOPMENT SHORTCUTS
# ─────────────────────────────────────────────────────────────────────────────────────────────────

# Python
alias py='python3'
alias python='python3'
alias pip='pip3'

# Node.js
alias npm-global='npm list -g --depth=0'

# Docker
alias dc='docker-compose'
alias dps='docker ps'
alias di='docker images'

# ─────────────────────────────────────────────────────────────────────────────────────────────────
# SAFETY ALIASES
# ─────────────────────────────────────────────────────────────────────────────────────────────────

alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
alias ln='ln -i'

# Safer rm with trash if available
if command -v trash >/dev/null 2>&1; then
    alias del='trash'
fi

# ─────────────────────────────────────────────────────────────────────────────────────────────────
# UTILITY FUNCTIONS
# ─────────────────────────────────────────────────────────────────────────────────────────────────

# Extract various archive formats
extract() {
    if [ -f "$1" ]; then
        case "$1" in
            *.tar.bz2) tar xjf "$1" ;;
            *.tar.gz) tar xzf "$1" ;;
            *.bz2) bunzip2 "$1" ;;
            *.rar) unrar x "$1" ;;
            *.gz) gunzip "$1" ;;
            *.tar) tar xf "$1" ;;
            *.tbz2) tar xjf "$1" ;;
            *.tgz) tar xzf "$1" ;;
            *.zip) unzip "$1" ;;
            *.Z) uncompress "$1" ;;
            *.7z) 7z x "$1" ;;
            *) echo "'$1' cannot be extracted via extract()" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}