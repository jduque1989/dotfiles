# Fig pre block. Keep at the top of this file.
[[ -f "$HOME/.fig/shell/bashrc.pre.bash" ]] && builtin source "$HOME/.fig/shell/bashrc.pre.bash"
orange=$(tput setaf 166);
yellow=$(tput setaf 228);
green=$(tput setaf 71);
white=$(tput setaf 15); 
bold=$(tput bold);
reset=$(tput sgr0);

export PATH=/usr/local/bin:$PATH

PS1="\[${bold}\]\n";
PS1+="\[${orange}\]\u";
PS1+="\[${white}\]@ ";
PS1+="\[${yellow}\]bash";
PS1+="\[${white}\] in ";
PS1+="\[${green}\]\W";
# PS1+="\n";
PS1+="\[${white}\] \$ \[${reset}\]";
export PS1;
. "$HOME/.cargo/env"

# Fig post block. Keep at the bottom of this file.
[[ -f "$HOME/.fig/shell/bashrc.post.bash" ]] && builtin source "$HOME/.fig/shell/bashrc.post.bash"

[ -f ~/.fzf.bash ] && source ~/.fzf.bash

 alias clr="clear"
 alias shut="sudo shutdown -h now"

 #General Apps
 alias v="nvim"
 alias lv="lvim"
 alias linode="ssh -i ~/.ssh/linode2 juanduque@170.187.153.8"
 alias dermalife="ssh -i ~/.ssh/webmaster_dermalife webmaster@74.207.224.117"
 alias dermalife2="ssh -i ~/.ssh/dermalife2 root@74.207.224.117"
 alias vpn-up="sudo wg-quick up wg0"
 alias vpn-down="sudo wg-quick down wg0"
 alias python="python3.12"

 #General aliases
 alias edgen="ssh -i ~/.ssh/edgenmurray root@50.116.24.131"
 alias edgenw="ssh -i ~/.ssh/edgenmurray webmaster@50.116.24.131"
 alias ..="cd .."
 alias h="cd ~/"
 alias du="du -sh *"
 alias ls="exa"
 alias ll="exa -la"

