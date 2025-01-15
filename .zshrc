# zmodload zsh/zprof
# source "$HOME/.zsh/spaceship/spaceship.zsh"
# source "$HOME/.config/starship.toml"
# ZIM_HOME=~/.zim

# SPACESHIP_PROMPT_ORDER=(
#   user          # Username section
#   dir           # Current directory section
#   git           # Git section (git_branch + git_status)
#   exec_time     # Execution time
#   line_sep      # Line break
#   battery       # Battery level and status
#   jobs          # Background jobs indicator
#   exit_code     # Exit code section
#   char          # Prompt character
# )
# SPACESHIP_PROMPT_ADD_NEWLINE=false
# SPACESHIP_PROMPT_FIRST_PREFIX_SHOW=true
# SPACESHIP_CHAR_SYMBOL="❯"
# SPACESHIP_CHAR_SUFFIX=" "
# SPACESHIP_CHAR_COLOR_SUCCESS=green
# SPACESHIP_PROMPT_SEPARATE_LINE=false
# SPACESHIP_PROMPT_ASYNC=false
# SPACESHIP_ASYNC_SHOW_COUNT=false


# # Download zimfw plugin manager if missing.
# if [[ ! -e ${ZIM_HOME}/zimfw.zsh ]]; then
#   curl -fsSL --create-dirs -o ${ZIM_HOME}/zimfw.zsh \
#       https://github.com/zimfw/zimfw/releases/latest/download/zimfw.zsh
# fi

# # Install missing modules, and update ${ZIM_HOME}/init.zsh if missing or outdated.
# if [[ ! ${ZIM_HOME}/init.zsh -nt ${ZDOTDIR:-${HOME}}/.zimrc ]]; then
#   source ${ZIM_HOME}/zimfw.zsh init -q
# fi

# Initialize modules.
fpath+=~/.zfunc
autoload -Uz compinit && compinit
# export PATH="/opt/homebrew/bin":$PATH
# eval $(thefuck --alias)
eval "$(starship init zsh)"

export PATH="$HOME/.pyenv/bin:$PATH"
eval "$(pyenv init --path)"
eval "$(pyenv init -)"

# eval $(thefuck --alias fuck)



# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/Users/juandavidduquea/miniforge3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/Users/juandavidduquea/miniforge3/etc/profile.d/conda.sh" ]; then
        . "/Users/juandavidduquea/miniforge3/etc/profile.d/conda.sh"
    else
        export PATH="/Users/juandavidduquea/miniforge3/bin:$PATH"
    fi
fi
unset __conda_setup

if [ -f "/Users/juandavidduquea/miniforge3/etc/profile.d/mamba.sh" ]; then
    . "/Users/juandavidduquea/miniforge3/etc/profile.d/mamba.sh"
fi
# <<< conda initialize <<<
eval "$(zoxide init --cmd cd zsh)"
<<<<<<< HEAD
# zprof
=======

# Set up bun
export BUN_INSTALL="$HOME/Library/Application Support/reflex/bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# Enable compinit cache
zstyle ':completion::complete:*' use-cache on
zstyle ':completion::complete:*' cache-path ~/.zsh/cache

# Initialize compinit with cache
autoload -Uz compinit
compinit -C

# Lazy load completion
zshaddhistory() {
  autoload -U compinit && compinit
  zshaddhistory() { return 0 }
}
export PATH="/opt/homebrew/opt/llvm/bin:$PATH"
export LLVM_CONFIG=/path/to/llvm-10/bin/llvm-config

# Load environment variables from .env
if [ -f ~/.env ]; then
    set -a
    . ~/.env
    set +a
fi
