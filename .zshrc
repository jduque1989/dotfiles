# Set ZIM_HOME if not set
export ZIM_HOME="${ZIM_HOME:-${HOME}/.zim}"

# Prevent early compinit by tools like zoxide or starship
DISABLE_COMPFIX=true
autoload -Uz compinit && unfunction compinit

# Load Zim
if [[ ! ${ZIM_HOME}/init.zsh -nt ${HOME}/.zimrc ]]; then
  source "${ZIM_HOME}/zimfw.zsh"
  zimfw init -q
fi
source "${ZIM_HOME}/init.zsh"

eval "$(starship init zsh)"

export PATH="$HOME/.pyenv/bin:$HOME/Library/Application Support/reflex/bun/bin:/opt/homebrew/opt/llvm/bin:$HOME/.npm-global/bin:./.venv/bin:$PATH"
export RX_NODE_PATH=$(which node)
source ~/zsh-defer/zsh-defer.plugin.zsh
# Lazy load heavy tools
zsh-defer 'sleep 0.5 && eval "$(pyenv init --path)" &!'
zsh-defer 'sleep 0.5 && eval "$(pyenv init -)" &!'
# zsh-defer eval "$(pyenv init --path)"
# zsh-defer eval "$(pyenv init -)"
zsh-defer eval "$(zoxide init --cmd cd zsh)"

# Compinit (usado por Zim)
zstyle ':completion::complete:*' use-cache on
zstyle ':completion::complete:*' cache-path ~/.zsh/cache

# Env variables
zsh-defer '[ -f ~/.env ] && set -a && source ~/.env && set +a'
