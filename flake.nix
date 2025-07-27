{
  description = "Juan David's macOS Nix Flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, home-manager }:
  let
    username = "juandavidduquea";
    configuration = { pkgs, ... }: {
      # List packages installed in system profile
      environment.systemPackages = with pkgs; [
        # Essential tools
        git
        curl
        wget
        tree
        htop
        
        # Modern CLI replacements
        eza        # ls replacement
        bat        # cat replacement
        fd         # find replacement
        ripgrep    # grep replacement
        fzf        # fuzzy finder
        
        # Development tools
        neovim
        tmux
        
        # Python
        python3
        
        # Other utilities
        jq
      ];

      # Nix configuration
      nix.settings = {
        experimental-features = [ "nix-command" "flakes" ];
      };
      
      # Enable automatic store optimization
      nix.optimise.automatic = true;

      # Create /etc/zshrc that loads the nix-darwin environment
      programs.zsh.enable = true;

      # Set Git commit hash for darwin-version
      system.configurationRevision = self.rev or self.dirtyRev or null;

      # Used for backwards compatibility
      system.stateVersion = 4;

      # The platform the configuration will be used on
      nixpkgs.hostPlatform = "aarch64-darwin";
    };
  in
  {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#simple
    darwinConfigurations."simple" = nix-darwin.lib.darwinSystem {
      modules = [ configuration ];
    };

    # Expose the package set, including overlays, for convenience
    darwinPackages = self.darwinConfigurations."simple".pkgs;
  };
}