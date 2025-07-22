
# -----------------------------------------------------------------------------
# ENVIRONMENT VARIABLES
# -----------------------------------------------------------------------------
export EDITOR="nvim"
export OPENAI_API_KEY="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"  # moved to .env in deferred step

# Fixed paths to avoid slow evals
export RX_NODE_PATH="/opt/homebrew/bin/node"
export PATH="$HOME/.pyenv/bin:/opt/homebrew/opt/llvm/bin:$HOME/.npm-global/bin:$HOME/.cargo/bin:$(npm config get prefix)/bin:$PATH"
