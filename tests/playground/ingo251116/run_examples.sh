#!/usr/bin/env bash
# Script to run the DivergenceTheorem examples
# This assumes Lean has been built in the repository

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LEAN4_ROOT="$(cd "$SCRIPT_DIR/../../.." && pwd)"

echo "=== Divergence Theorem - Computational Examples ==="
echo ""
echo "This script demonstrates the Lean formalization of the divergence theorem"
echo "for the Collatz-type recursion T(n) = ⌊√2·n + 4⌋ / 2^(ν₂(⌊√2·n + 4⌋))."
echo ""

# Check if lean executable exists
if [ ! -f "$LEAN4_ROOT/bin/lean" ]; then
    echo "Error: Lean executable not found at $LEAN4_ROOT/bin/lean"
    echo "Please build Lean first:"
    echo "  cd $LEAN4_ROOT"
    echo "  cmake --preset release"
    echo "  make -C build/release"
    exit 1
fi

LEAN="$LEAN4_ROOT/bin/lean"

echo "Using Lean: $LEAN"
echo "Lean version:"
$LEAN --version
echo ""

# Create a temporary file with evaluation commands
TEMP_FILE=$(mktemp)
cat > "$TEMP_FILE" << 'EOF'
import DivergenceTheorem

open CollatzDivergence

-- Display first 15 orbit values starting from n₀ = 1
#eval IO.println "Orbit starting at n₀ = 1 (first 15 values):"
#eval IO.println ((List.range 15).map (orbit 1))

-- Show detailed orbit information
#eval IO.println "\nDetailed orbit information (first 10 steps):"
#eval detailedOrbit 1 10

-- Check growth pattern
#eval IO.println "\nGrowth pattern (value, did_grow) for first 20 steps:"
#eval checkOrbitGrowth 1 20

-- Compute some specific values to compare with Table 1
#eval IO.println "\nComparison with paper Table 1:"
#eval IO.println ("t=0: " ++ toString (orbit 1 0) ++ " (expected: 1)")
#eval IO.println ("t=1: " ++ toString (orbit 1 1) ++ " (expected: 5)")
#eval IO.println ("t=2: " ++ toString (orbit 1 2) ++ " (expected: 11)")
#eval IO.println ("t=3: " ++ toString (orbit 1 3) ++ " (expected: 19)")
#eval IO.println ("t=10: " ++ toString (orbit 1 10) ++ " (expected: 183)")
#eval IO.println ("t=20: " ++ toString (orbit 1 20) ++ " (expected: 3159)")
#eval IO.println ("t=30: " ++ toString (orbit 1 30) ++ " (expected: 25379)")
EOF

echo "Running examples from DivergenceTheorem.lean..."
echo ""

cd "$SCRIPT_DIR"
$LEAN "$TEMP_FILE"

rm "$TEMP_FILE"

echo ""
echo "=== Examples completed ==="
echo ""
echo "For more information, see:"
echo "  - README.md: Overview of the formalization"
echo "  - COMPARISON.md: Comparison with paper results"
echo "  - DivergenceTheorem.lean: Full Lean source code"
