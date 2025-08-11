#!/bin/zsh
# Quick shell startup benchmark using ZSH timing

echo "⏱️  Quick Shell Startup Benchmark"
echo "================================="
echo ""

# Simple timing test
echo "🧪 Testing shell startup time (5 iterations):"
echo ""

for i in {1..5}; do
    echo -n "Run $i: "
    time ( zsh -i -c 'exit' ) 2>&1 | grep real | awk '{print $2}'
done

echo ""
echo "🎯 Manual timing test:"
echo "Run this command to test yourself:"
echo "   time zsh -i -c 'exit'"
echo ""

echo "💡 Interpretation:"
echo "   • real time = actual time elapsed"
echo "   • user time = CPU time in user mode" 
echo "   • sys time  = CPU time in system mode"
echo ""
echo "🎯 Target: real time should be < 0.2s for good performance"