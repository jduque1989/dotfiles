#!/bin/zsh
# ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
# ┃                                  🔍 Shell Startup Diagnostics                                     ┃
# ┃                             Identify performance bottlenecks                                      ┃
# ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

echo "🔍 Shell Startup Diagnostic Report"
echo "=================================="
echo ""

# Function to time a command
time_command() {
    local description="$1"
    local command="$2"
    local start_time=$(date +%s.%N)
    
    echo -n "⏱️  $description... "
    eval "$command" >/dev/null 2>&1
    
    local end_time=$(date +%s.%N)
    local duration=$(echo "$end_time - $start_time" | bc -l)
    printf "%6.3fs\n" $duration
    
    if (( $(echo "$duration > 0.1" | bc -l) )); then
        echo "   ⚠️  This step is slow (>0.1s)"
    fi
}

echo "🧪 Testing individual components:"
echo ""

# Check if bc is available
if ! command -v bc >/dev/null 2>&1; then
    echo "Installing bc for timing calculations..."
    brew install bc 2>/dev/null
fi

# Test basic shell loading
time_command "Basic ZSH load" "zsh -c 'echo loaded'"

# Test ZIM initialization
time_command "ZIM framework init" "zsh -c 'source ~/.zim/init.zsh'"

# Test custom modules
time_command "Core module" "zsh -c 'source ~/.config/.zsh/modules/core.zsh'"
time_command "Aliases module" "zsh -c 'source ~/.config/.zsh/modules/aliases.zsh'" 
time_command "Functions module" "zsh -c 'source ~/.config/.zsh/modules/functions.zsh'"
time_command "Prompt module" "zsh -c 'source ~/.config/.zsh/modules/prompt.zsh'"

# Test Starship
time_command "Starship initialization" "zsh -c 'eval \"\$(starship init zsh)\"'"

# Test heavy operations
time_command "PyEnv initialization" "zsh -c 'eval \"\$(pyenv init --path)\" 2>/dev/null || true'"
time_command "PyEnv shell setup" "zsh -c 'eval \"\$(pyenv init -)\" 2>/dev/null || true'"
time_command "Zoxide initialization" "zsh -c 'eval \"\$(zoxide init --cmd cd zsh)\" 2>/dev/null || true'"

echo ""
echo "🔍 Checking for potential issues:"
echo ""

# Check file sizes
echo "📁 Configuration file sizes:"
ls -lah ~/.zshrc ~/.zimrc ~/.config/.zsh/modules/*.zsh 2>/dev/null | awk '{print "  " $5 " " $9}' | grep -E "\.(zsh|zshrc|zimrc)$"

echo ""
echo "💾 Compiled files status:"
compiled_count=$(find ~/.config/.zsh ~/.zim ~ -maxdepth 3 -name "*.zwc" -type f 2>/dev/null | wc -l | xargs)
echo "  Compiled .zwc files: $compiled_count"

# Check for large history files
echo ""
echo "📈 History file size:"
if [[ -f ~/.zsh_history ]]; then
    ls -lah ~/.zsh_history | awk '{print "  " $5 " ~/.zsh_history"}'
else
    echo "  No history file found"
fi

# Check for problematic plugins or configurations
echo ""
echo "🔌 Active ZIM modules:"
if [[ -f ~/.zimrc ]]; then
    grep "^zmodule" ~/.zimrc | wc -l | xargs echo "  Total modules:"
    echo "  Modules:"
    grep "^zmodule" ~/.zimrc | sed 's/^/    /'
fi

echo ""
echo "🚨 Potential performance issues:"

# Check for slow network operations
if grep -q "curl\|wget\|git.*clone" ~/.zshrc ~/.config/.zsh/modules/*.zsh 2>/dev/null; then
    echo "  ⚠️  Network operations found in startup files"
fi

# Check for expensive computations
if grep -qE "find|sort|awk.*-F|sed.*-e" ~/.zshrc ~/.config/.zsh/modules/*.zsh 2>/dev/null; then
    echo "  ⚠️  Potentially expensive commands in startup"
fi

# Check deferred loading
if grep -q "zsh-defer" ~/.zshrc; then
    echo "  ✅ zsh-defer found - good for performance"
else
    echo "  ⚠️  No zsh-defer usage detected"
fi

echo ""
echo "💡 Recommendations:"
echo "  • Items >0.1s should be investigated"
echo "  • Consider deferring slow operations with zsh-defer"
echo "  • Large history files can be cleaned up"
echo "  • Network operations should be avoided in startup"
echo ""
echo "✅ Diagnostic complete!"