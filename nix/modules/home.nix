{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the
  # paths it should manage
  home.username = "juandavidduquea";
  home.homeDirectory = "/Users/juandavidduquea";

  # This value determines the Home Manager release that your
  # configuration is compatible with
  home.stateVersion = "23.05";

  # Packages that should be installed to the user profile
  home.packages = with pkgs; [
    # Development tools
    gh          # GitHub CLI
    
    # File management
    ranger
    
    # Music
    spotify-tui
    spotifyd
    
    # System monitoring
    neofetch
    
    # Archive tools
    unzip
    zip
  ];

  # Home Manager can also manage your shell configuration
  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    enableCompletion = true;
    
    # We'll let your existing .zshrc handle the configuration
    # but ensure Nix packages are in PATH
    initExtra = ''
      # Ensure Nix packages are in PATH
      if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
        . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
      fi
    '';
  };

  # Git configuration
  programs.git = {
    enable = true;
    # Add your git configuration here if desired
    # userName = "Your Name";
    # userEmail = "your.email@example.com";
  };

  # Let Home Manager install and manage itself
  programs.home-manager.enable = true;
}