# ~/.zsh/modules/fzf-config.zsh

export FZF_DEFAULT_OPTS="--height 50% --layout=reverse --border \
  --color=hl:#2dd4bf,hl+:#2dd4bf,info:#facc15,prompt:#ec4899,pointer:#2dd4bf,marker:#2dd4bf,spinner:#2dd4bf,header:#64748b \
  --bind 'ctrl-/:change-preview-window(down|hidden|right)' \
  --bind 'ctrl-alt-j:preview-down' \
  --bind 'ctrl-alt-k:preview-up' \
  --prompt '🔍 ' --pointer '▶' --marker '✓'"

export FZF_DEFAULT_COMMAND="fd --type f --hidden --strip-cwd-prefix --exclude .git --exclude node_modules --exclude .venv --exclude .cache"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd --type d --hidden --strip-cwd-prefix --exclude .git --exclude node_modules --exclude .venv --exclude .cache --max-depth 4"
