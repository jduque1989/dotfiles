# Nix Configuration for ZSH
# This module handles Nix integration with your shell

# Source the Nix daemon profile if it exists
if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
  source '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
fi

# Add Nix packages to PATH (in case not already done)
if [ -d "/nix/var/nix/profiles/default/bin" ]; then
  export PATH="/nix/var/nix/profiles/default/bin:$PATH"
fi

# Nix-specific aliases
alias nix-update="darwin-rebuild switch --flake ~/.dotfiles#simple"
alias nix-rollback="darwin-rebuild rollback"
alias nix-list="nix profile list"
alias nix-search="nix search nixpkgs"

# Nix functions
nix-shell-run() {
  if [ -z "$1" ]; then
    echo "Usage: nix-shell-run <package> [command]"
    echo "Example: nix-shell-run python3 python --version"
    return 1
  fi
  
  local package="$1"
  shift
  nix shell "nixpkgs#$package" -c "${@:-$SHELL}"
}

# Function to quickly edit Nix configuration
nix-config() {
  nvim ~/.dotfiles/flake.nix
}

nix-home-config() {
  nvim ~/.dotfiles/nix/modules/home.nix
}