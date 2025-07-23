# =============================================================================
# CORE.ZSH – Configuraciones esenciales del entorno shell
# =============================================================================

# 🧠 Historial inteligente
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt APPEND_HISTORY          # Agrega en lugar de sobrescribir
setopt HIST_IGNORE_ALL_DUPS    # Evita duplicados en el historial
setopt SHARE_HISTORY           # Comparte historial entre sesiones

# 🧼 Comportamiento de expansión y globbing
setopt EXTENDED_GLOB
setopt NO_BEEP
setopt AUTO_CD
setopt AUTO_PUSHD
setopt PUSHD_IGNORE_DUPS

# ⌨️ Configuración del editor y completado
export EDITOR='nvim'
autoload -Uz compinit && compinit -d "${ZDOTDIR:-$HOME}/.zcompdump"

# 🛣️ Path y variables comunes
export PATH="$HOME/.local/bin:$HOME/.npm-global/bin:$HOME/.cargo/bin:$PATH"
export NODE_PATH="/opt/homebrew/bin/node"
export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"

# 🧩 Plugins adicionales como pyenv o asdf deben cargarse aquí si es necesario
[[ -s "$HOME/.pyenv/init.zsh" ]] && source "$HOME/.pyenv/init.zsh"

# 🗂️ Zoxide (smart cd replacement)
eval "$(zoxide init --cmd cd zsh)"
