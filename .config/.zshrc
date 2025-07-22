# ~/.zshrc
# 🚀 Carga directa sin .zwc

# Carga zsh-defer
source ~/zsh-defer/zsh-defer.plugin.zsh

# Carga inmediata
for file in ~/.zsh/modules/core.zsh ~/.zsh/modules/prompt.zsh ~/.zsh/modules/aliases.zsh; do
  source "$file"
done

# Carga diferida
for file in ~/.zsh/modules/*.zsh(N); do
  case "$file" in
    (*core.zsh|*prompt.zsh|*aliases.zsh) continue ;;
    (*) zsh-defer -t 0 "source \"$file\"" ;;
  esac
done
