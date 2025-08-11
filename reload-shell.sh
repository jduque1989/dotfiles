#!/bin/zsh
# Clean shell reload script

echo "🔄 Reloading shell configuration..."

# Clear function cache
unset -f get_battery_status get_memory_usage get_shell_info show_system_info 2>/dev/null

# Clear any completion cache
rm -f ~/.zcompdump* 2>/dev/null

# Source the configuration
source ~/.zshrc

echo "✅ Shell configuration reloaded"
echo "🧪 Testing functions:"

get_battery_status
get_memory_usage  
show_system_info