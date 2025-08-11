#!/bin/zsh
# ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
# ┃                                🚀 ZSH Configuration Compiler                                      ┃
# ┃                              Optimize shell startup performance                                   ┃
# ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

echo "🔧 Compiling ZSH configuration files for optimal performance..."

# Function to compile a file with error checking
compile_file() {
    local file="$1"
    local description="$2"
    
    if [[ -f "$file" ]]; then
        echo -n "  📄 Compiling $description... "
        if zcompile "$file" 2>/dev/null; then
            echo "✅"
        else
            echo "❌ (failed)"
        fi
    else
        echo "  ⚠️  $file not found, skipping"
    fi
}

# Remove existing compiled files first
echo "🗑️  Cleaning old compiled files..."
find ~/.config/.zsh ~/.zim -name "*.zwc" -type f -exec rm -f {} \; 2>/dev/null
rm -f ~/.zshrc.zwc ~/.zcompdump.zwc 2>/dev/null

echo ""
echo "📦 Compiling main configuration files..."

# Compile main .zshrc
compile_file ~/.zshrc "main .zshrc"

# Compile .zimrc
compile_file ~/.zimrc "ZIM configuration"

echo ""
echo "🔧 Compiling custom ZSH modules..."

# Compile custom modules
compile_file ~/.config/.zsh/modules/core.zsh "core module"
compile_file ~/.config/.zsh/modules/aliases.zsh "aliases module"  
compile_file ~/.config/.zsh/modules/functions.zsh "functions module"
compile_file ~/.config/.zsh/modules/prompt.zsh "prompt module"
compile_file ~/.config/.zsh/modules/env.zsh "environment module"
compile_file ~/.config/.zsh/modules/fzf-config.zsh "fzf configuration"
compile_file ~/.config/.zsh/modules/plugins.zsh "plugins module"

echo ""
echo "⚡ Compiling ZIM framework files..."

# Compile ZIM files
compile_file ~/.zim/init.zsh "ZIM initialization"
compile_file ~/.zim/zimfw.zsh "ZIM framework"

# Compile ZIM modules
if [[ -d ~/.zim/modules ]]; then
    for module_dir in ~/.zim/modules/*/; do
        if [[ -d "$module_dir" ]]; then
            module_name=$(basename "$module_dir")
            echo "  🧩 Compiling ZIM module: $module_name"
            
            # Use find to avoid glob issues
            find "$module_dir" -maxdepth 1 -name "*.zsh" -type f 2>/dev/null | while read zsh_file; do
                if [[ -f "$zsh_file" ]]; then
                    compile_file "$zsh_file" "$(basename "$zsh_file")"
                fi
            done
        fi
    done
fi

echo ""
echo "🔄 Compiling completion files..."

# Compile completion dump if it exists
if [[ -f ~/.zcompdump ]]; then
    compile_file ~/.zcompdump "completion dump"
fi

# Compile completion functions
if [[ -d ~/.zim/modules/completion/functions ]]; then
    find ~/.zim/modules/completion/functions -maxdepth 1 -type f ! -name "*.zwc" 2>/dev/null | while read func_file; do
        if [[ -f "$func_file" ]]; then
            compile_file "$func_file" "completion function $(basename "$func_file")"
        fi
    done
fi

echo ""
echo "📊 Compilation Summary:"
echo "  📁 Compiled files created:"
find ~/.config/.zsh ~/.zim ~ -maxdepth 3 -name "*.zwc" -type f 2>/dev/null | wc -l | xargs echo "    Total .zwc files:"

echo ""
echo "✅ ZSH compilation complete!"
echo "🚀 Restart your terminal to experience faster startup times!"
echo ""
echo "💡 Tip: Run this script after making changes to your ZSH configuration"
echo "    to maintain optimal performance."