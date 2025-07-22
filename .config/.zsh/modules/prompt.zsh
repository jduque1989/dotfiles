# =============================================================================
# PROMPT.ZSH – Configura el prompt visual
# =============================================================================

# Puedes usar uno u otro: Starship o Powerlevel10k

# 🚀 STARSHIP (moderno, rápido y configurado por archivo toml)
if command -v starship >/dev/null 2>&1; then
  eval "$(starship init zsh)"
  export STARSHIP_CONFIG="$HOME/.config/starship.toml"
fi

# 🔮 POWERLEVEL10K (comenta si usas starship)
# [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# 🎨 Opcional: color para terminal sin prompt managers
autoload -Uz colors && colors

# 🧪 Alias útil para probar el prompt
alias reload-prompt='source ~/.zsh/modules/prompt.zsh'
