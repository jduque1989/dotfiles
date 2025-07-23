# ~/.zshrc
# 🚀 Carga directa sin .zwc

# Carga zsh-defer
source ~/zsh-defer/zsh-defer.plugin.zsh

# Carga inmediata
for file in ~/.config/.zsh/modules/core.zsh ~/.config/.zsh/modules/prompt.zsh ~/.config/.zsh/modules/aliases.zsh ~/.config/.zsh/modules/functions.zsh; do
  source "$file"
done

# Carga diferida
for file in ~/.config/.zsh/modules/*.zsh(N); do
  case "$file" in
    (*core.zsh|*prompt.zsh|*aliases.zsh|*functions.zsh) continue ;;
    (*) zsh-defer -t 0 "source \"$file\"" ;;
  esac
done
