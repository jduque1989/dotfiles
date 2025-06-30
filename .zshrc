# Set up ZIM (if you decide to use it, uncomment the lines below)
# ZIM_HOME="${ZDOTDIR:-${HOME}}/.zim"
# if [[ ! -e ${ZIM_HOME}/zimfw.zsh ]]; then
#     curl -fsSL --create-dirs -o ${ZIM_HOME}/zimfw.zsh \
#         https://github.com/zimfw/zimfw/releases/latest/download/zimfw.zsh
# fi
# if [[ ! ${ZIM_HOME}/init.zsh -nt ${ZDOTDIR:-${HOME}}/.zimrc ]]; then
#     source ${ZIM_HOME}/zimfw.zsh init -q
# fi

# PATH Configuration
export PATH="$HOME/.pyenv/bin:$HOME/Library/Application Support/reflex/bun/bin:/opt/homebrew/opt/llvm/bin:$PATH"

# Pyenv Initialization
eval "$(pyenv init --path)"
eval "$(pyenv init -)"

# Starship Prompt
eval "$(starship init zsh)"

# Conda Initialization
if [ -f "/Users/juandavidduquea/miniforge3/etc/profile.d/conda.sh" ]; then
    . "/Users/juandavidduquea/miniforge3/etc/profile.d/conda.sh"
else
    export PATH="/Users/juandavidduquea/miniforge3/bin:$PATH"
fi

# Mamba Initialization
if [ -f "/Users/juandavidduquea/miniforge3/etc/profile.d/mamba.sh" ]; then
    . "/Users/juandavidduquea/miniforge3/etc/profile.d/mamba.sh"
fi

# Zoxide Initialization
eval "$(zoxide init --cmd cd zsh)"

# Compinit Setup
autoload -Uz compinit
zstyle ':completion::complete:*' use-cache on
zstyle ':completion::complete:*' cache-path ~/.zsh/cache

# Initialize compinit with cache
autoload -Uz compinit
compinit -C

# Load Environment Variables
if [ -f ~/.env ]; then
    set -a
    . ~/.env
    set +a
fi

# LLVM Configuration
export LLVM_CONFIG="/path/to/llvm-10/bin/llvm-config"

# Lazy Load Compinit (optional for advanced users)
zshaddhistory() {
    autoload -U compinit && compinit
    zshaddhistory() { return 0 }
}
export PATH=$HOME/.npm-global/bin:$PATH
