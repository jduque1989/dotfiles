# ~/.zsh/modules/functions.zsh
# Enable fzf keybindings and completion
if command -v fzf &> /dev/null; then
  # Load fzf key bindings and completion
  [ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
  
  # Alternative locations for fzf (Homebrew)
  if [[ ! -f ~/.fzf.zsh ]]; then
    [ -f /opt/homebrew/opt/fzf/shell/key-bindings.zsh ] && source /opt/homebrew/opt/fzf/shell/key-bindings.zsh
    [ -f /opt/homebrew/opt/fzf/shell/completion.zsh ] && source /opt/homebrew/opt/fzf/shell/completion.zsh
  fi
fi

# 1. Kill process with fzf (renamed to avoid alias conflict)
fzf_kill() {
  local pid
  pid=$(ps -ef | sed 1d | fzf --multi | awk '{print $2}')
  if [ -n "$pid" ]; then
    echo "$pid" | xargs kill -9
  fi
}

# 2. Change directory with fzf
cf() {
  local dir
  dir=$(fd --type d --hidden --max-depth 4 --exclude .git --exclude node_modules --exclude .venv . | fzf --preview 'eza -la --color=always --icons {}' --preview-window 'right:40%')
  if [[ -n "$dir" ]]; then
    cd "$dir"
    echo "📁 Changed to: $(pwd)"
  fi
}

# Alternative: cdf for searching from home directory
cdf() {
  local dir
  dir=$(fd --type d --hidden --max-depth 6 --exclude .git --exclude node_modules --exclude .venv . ~ | fzf --preview 'eza -la --color=always --icons {}' --preview-window 'right:40%')
  if [[ -n "$dir" ]]; then
    cd "$dir"
    echo "📁 Changed to: $(pwd)"
  fi
}

# 3. Open file with Neovim using fzf
vf() {
  local file
  file=$(fd --type f --hidden --exclude .git --exclude node_modules --exclude .venv . | fzf --preview 'bat --color=always --style=header,grid --line-range :300 {}' --preview-window 'right:60%')
  if [[ -n "$file" ]]; then
    nvim "$file"
  fi
}

# Alternative: vff for searching from home directory
vff() {
  local file
  file=$(fd --type f --hidden --exclude .git --exclude node_modules --exclude .venv . ~ | fzf --preview 'bat --color=always --style=header,grid --line-range :300 {}' --preview-window 'right:60%')
  if [[ -n "$file" ]]; then
    nvim "$file"
  fi
}
