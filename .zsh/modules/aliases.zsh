# ~/.zsh/modules/aliases.zsh

alias v='nvim'
alias ls='eza --icons'
alias ll='eza -lah --icons'
alias la='eza -la --icons'
alias lt='eza -T --icons'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias reload='source ~/.config/.zshrc'
alias zshrc='nvim ~/.config/.zshrc'
alias fzf='fzf --preview "bat --style=numbers --color=always {}" --preview-window=right:50%'
alias y='yazi'
alias as='aerospace'
ff() {
  aerospace list-windows --all | \
  fzf --no-preview \
  --bind 'enter:execute(bash -c "aerospace focus --window-id {1}")+abort'
}
