#!/usr/bin/env bash
if [ $# -eq 0 ]; then
    echo "Usage: compile.sh [file]"
    exit 1
fi

ulimit -s 8192

# Find the Lean root directory (3 levels up from this script)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LEAN_ROOT="$(cd "$SCRIPT_DIR/../../.." && pwd)"

# Try to find lean and leanc binaries in multiple locations
if [ -f "$LEAN_ROOT/bin/lean" ]; then
    BIN_DIR="$LEAN_ROOT/bin"
elif [ -f "$LEAN_ROOT/build/release/stage1/bin/lean" ]; then
    BIN_DIR="$LEAN_ROOT/build/release/stage1/bin"
elif [ -f "$LEAN_ROOT/build/release/stage0/bin/lean" ]; then
    BIN_DIR="$LEAN_ROOT/build/release/stage0/bin"
elif [ -f "$LEAN_ROOT/stage0/bin/lean" ]; then
    BIN_DIR="$LEAN_ROOT/stage0/bin"
else
    echo "Error: Could not find Lean binaries"
    echo "Please build Lean first with: cmake --preset release && make -C build/release"
    exit 1
fi

LEAN="$BIN_DIR/lean"
LEANC="$BIN_DIR/leanc"

echo "Using Lean: $LEAN"
echo "Using leanc: $LEANC"

export LEAN_PATH=Init="$LEAN_ROOT/library/Init":Test=.

ff=$1

if [[ "$OSTYPE" == "msys" ]]; then
    # Windows running MSYS2
    # Replace /c/ with c:, and / with \\
    ff=$(echo $ff  | sed 's|^/\([a-z]\)/|\1:/|' | sed 's|/|\\\\|g')
fi

echo "Compiling $ff to C++..."
$LEAN -c "$ff.cpp" "$ff"
if [ $? -ne 0 ]; then
    echo "Failed to compile $ff into C++ file"
    exit 1
fi

echo "Compiling C++ to executable..."
# Use g++ directly if leanc is not available
if [ -x "$LEANC" ]; then
    $LEANC -O3 -DNDEBUG -o "$ff.out" "$ff.cpp"
else
    echo "leanc not found, using g++ directly..."
    g++ -O3 -DNDEBUG -I"$LEAN_ROOT/build/release/stage0/include" -o "$ff.out" "$ff.cpp" -lpthread -ldl
fi
if [ $? -ne 0 ]; then
    echo "Failed to compile C++ file $ff.cpp"
    exit 1
fi

echo "Success! Created $ff.out"
