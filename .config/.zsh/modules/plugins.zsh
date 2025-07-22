# ~/.zsh/modules/plugins.zsh

# Starship
eval "$(starship init zsh)"

# Pyenv
eval "$(pyenv init --path)"
eval "$(pyenv init -)"

# Zoxide
eval "$(zoxide init --cmd cd zsh)"

# FZF
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
