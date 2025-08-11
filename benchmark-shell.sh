#!/bin/zsh
# ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
# ┃                                   ⏱️  Shell Startup Benchmark                                     ┃
# ┃                              Measure terminal loading performance                                  ┃
# ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛

echo "🚀 Shell Startup Performance Benchmark"
echo "======================================="
echo ""

# Function to run benchmark
run_benchmark() {
    local test_name="$1"
    local test_command="$2"
    local iterations=10
    
    echo "📊 Testing: $test_name"
    echo "🔄 Running $iterations iterations..."
    
    local total_time=0
    local times=()
    
    for i in {1..$iterations}; do
        local start_time=$(date +%s.%N)
        eval "$test_command" >/dev/null 2>&1
        local end_time=$(date +%s.%N)
        
        local duration=$(echo "$end_time - $start_time" | bc -l)
        times+=($duration)
        total_time=$(echo "$total_time + $duration" | bc -l)
        
        printf "  Run %2d: %6.3fs\n" $i $duration
    done
    
    local average=$(echo "scale=3; $total_time / $iterations" | bc -l)
    
    # Calculate min and max
    local min_time=${times[1]}
    local max_time=${times[1]}
    
    for time in "${times[@]}"; do
        if (( $(echo "$time < $min_time" | bc -l) )); then
            min_time=$time
        fi
        if (( $(echo "$time > $max_time" | bc -l) )); then
            max_time=$time
        fi
    done
    
    echo ""
    echo "📈 Results for $test_name:"
    printf "  Average: %6.3fs\n" $average
    printf "  Minimum: %6.3fs\n" $min_time  
    printf "  Maximum: %6.3fs\n" $max_time
    echo "  ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
}

# Check if bc is available
if ! command -v bc >/dev/null 2>&1; then
    echo "❌ Error: 'bc' calculator not found. Installing..."
    if command -v brew >/dev/null 2>&1; then
        brew install bc
    else
        echo "Please install bc manually: brew install bc"
        exit 1
    fi
fi

echo "🧪 Starting benchmark tests..."
echo ""

# Test 1: Basic ZSH startup (just load .zshrc)
run_benchmark "Basic ZSH startup" "zsh -i -c 'exit'"

# Test 2: ZSH with function execution (more realistic)
run_benchmark "ZSH with function test" "zsh -i -c 'get_battery_status >/dev/null 2>&1; exit'"

# Test 3: Full shell session simulation
run_benchmark "Full shell simulation" "zsh -i -c 'pwd >/dev/null; ls >/dev/null; exit'"

echo "🎯 Performance Analysis:"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Get some system info for context
echo "💻 System Information:"
echo "  Shell: $(zsh --version)"
echo "  Terminal: $TERM_PROGRAM"
echo "  ZSH compiled files: $(find ~/.config/.zsh ~/.zim ~ -maxdepth 3 -name "*.zwc" -type f 2>/dev/null | wc -l | xargs)"
echo "  ZIM modules: $(find ~/.zim/modules -maxdepth 1 -type d 2>/dev/null | wc -l | xargs)"
echo ""

echo "💡 Performance Tips:"
echo "  🟢 Good performance: < 0.100s"
echo "  🟡 Moderate performance: 0.100s - 0.300s"  
echo "  🔴 Slow performance: > 0.300s"
echo ""

echo "✅ Benchmark complete!"
echo "💡 To improve performance further:"
echo "  • Run ./compile-zsh.sh after config changes"
echo "  • Consider removing unused ZIM modules"
echo "  • Use 'zsh-defer' for non-essential initializations"