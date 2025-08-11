#!/bin/zsh
# Test zoxide functionality

echo "🔍 Zoxide Configuration Test"
echo "============================"
echo ""

echo "📦 Installation Status:"
if command -v zoxide >/dev/null 2>&1; then
    echo "  ✅ Zoxide installed: $(which zoxide)"
    echo "  📊 Version: $(zoxide --version)"
else
    echo "  ❌ Zoxide not found"
    exit 1
fi

echo ""
echo "💾 Database Status:"
db_entries=$(zoxide query --list 2>/dev/null | wc -l | xargs)
if [[ $db_entries -gt 0 ]]; then
    echo "  ✅ Database has $db_entries entries"
    echo "  📂 Top 5 directories:"
    zoxide query --list | head -5 | sed 's/^/    /'
else
    echo "  ⚠️  Empty database - zoxide will learn as you navigate"
fi

echo ""
echo "🔧 Configuration Test:"

# Test if zoxide init works
if zoxide init zsh --cmd cd >/dev/null 2>&1; then
    echo "  ✅ Zoxide initialization works"
else
    echo "  ❌ Zoxide initialization failed"
fi

# Test in a subshell with zoxide enabled
echo "  🧪 Testing zoxide functionality..."
zsh -c '
    eval "$(zoxide init --cmd cd zsh)" 2>/dev/null
    
    if type cd | grep -q "function"; then
        echo "    ✅ cd command replaced with zoxide"
    else
        echo "    ❌ cd command not replaced"
    fi
    
    if command -v z >/dev/null 2>&1; then
        echo "    ✅ z command available"
    else
        echo "    ❌ z command not available"
    fi
    
    if command -v zi >/dev/null 2>&1; then
        echo "    ✅ zi (interactive) command available" 
    else
        echo "    ❌ zi command not available"
    fi
'

echo ""
echo "⚡ Performance Test:"
echo -n "  Zoxide init time: "
time (zoxide init --cmd cd zsh >/dev/null) 2>&1 | grep real | awk '{print $2}'

echo ""
echo "💡 Usage Tips:"
echo "  • cd <partial-name>  - Jump to frequently visited directory"
echo "  • z <partial-name>   - Same as cd, but shorter"
echo "  • zi                 - Interactive directory picker"
echo "  • zoxide query <term> - Search database without jumping"
echo ""
echo "✅ Zoxide test complete!"