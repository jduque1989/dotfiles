# Set PATH
# Consolidate PATH updates to minimize processing
export PATH="$HOME/.local/bin:$HOME/bin:/opt/homebrew/bin:$PATH"

# Set STARSHIP_CONFIG
export STARSHIP_CONFIG=~/.config/starship.toml

# Source essential files
# [ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
# source ~/.zim/zim_config.zsh


alias clr="clear"
alias shut="sudo shutdown -h now"


#General Apps
alias v="nvim"
alias lv="lvim"
# alias python="python3.12"

#General aliases
alias ..="cd .."
alias h="cd ~/"
alias du="du -sh *"
alias ls='lsd'
alias ll='ls -l'
alias la='ls -a'
alias lla='ls -la'
alias lt='ls --tree'

 # Set FZF default options
alias fcd='cd "$(find . -type d | fzf)"'
alias fkill='kill -9 $(ps aux | fzf | awk "{print \$2}")'
alias fe='lv $(find . -type f | fzf)'

# Ensure PATH modifications are only done if the directories exist
if [ -d "$HOME/.cargo/env" ]; then
  export PATH="$HOME/.cargo/env:$PATH"
fi
