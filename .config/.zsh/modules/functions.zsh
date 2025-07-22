# ~/.zsh/modules/functions.zsh

unalias vf 2>/dev/null; vf() {
  local file=$(fzf --preview 'bat --style=numbers --color=always --line-range=:500 {} 2>/dev/null' --preview-window=right:60%:wrap --prompt "📄 Choose file: ")
  [[ -n "$file" ]] && ${EDITOR:-nvim} "$file"
}

unalias cf 2>/dev/null; cf() {
  local dir=$(fd --type d --exclude .git --exclude node_modules --max-depth 4 . | fzf --preview='eza -TL 2 --icons --color=always {}' --preview-window=right:50%:wrap --prompt "📁 Choose dir: ")
  [[ -n "$dir" ]] && cd "$dir"
}
