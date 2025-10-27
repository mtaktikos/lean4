#!/usr/bin/env python3
"""
Test script for the cyclic sum inequality:
    ∑ᵢ₌₁ᴺ uᵢ(u²ᵢ₋₂ - 4u²ᵢ₋₁ + 3u²ᵢ) ≥ 0

This script allows testing the inequality with various inputs to search
for counterexamples or gain confidence in the conjecture.

Usage:
    python3 test_cyclic_sum.py
"""

def cyclic_sum(u):
    """
    Compute the cyclic sum: ∑ᵢ uᵢ(u²ᵢ₋₂ - 4u²ᵢ₋₁ + 3u²ᵢ)
    
    Args:
        u: List of non-negative numbers
        
    Returns:
        The value of the cyclic sum
    """
    N = len(u)
    total = 0
    
    for i in range(N):
        curr = u[i]
        prev1 = u[(i - 1) % N]  # uᵢ₋₁
        prev2 = u[(i - 2) % N]  # uᵢ₋₂
        
        term = curr * (prev2**2 - 4*prev1**2 + 3*curr**2)
        total += term
    
    return total


def test_specific_examples():
    """Test a set of specific examples."""
    examples = [
        ("All ones (N=3)", [1, 1, 1]),
        ("Alternating (N=3)", [1, 2, 1]),
        ("Large variation (N=3)", [1, 10, 1]),
        ("Linear (N=4)", [1, 2, 3, 4]),
        ("With zero (N=3)", [1, 0, 2]),
        ("Symmetric (N=5)", [1, 2, 3, 2, 1]),
        ("All ones (N=10)", [1] * 10),
    ]
    
    print("Specific Examples:")
    print("=" * 70)
    
    for name, u in examples:
        result = cyclic_sum(u)
        status = "✓" if result >= -1e-10 else "✗"
        print(f"{status} {name:30s}: u = {str(u):30s} → {result:10.2f}")
    
    print()


def test_random_examples(n_trials=100, max_n=5):
    """Test random examples."""
    import random
    random.seed(42)
    
    print(f"Random Examples ({n_trials} trials per N):")
    print("=" * 70)
    
    counterexample_found = False
    
    for N in range(2, max_n + 1):
        min_sum = float('inf')
        max_sum = float('-inf')
        negative_count = 0
        
        for _ in range(n_trials):
            u = [random.uniform(0, 10) for _ in range(N)]
            result = cyclic_sum(u)
            
            if result < -1e-10:
                negative_count += 1
                print(f"  COUNTEREXAMPLE: N={N}, u={u}, sum={result}")
                counterexample_found = True
            
            min_sum = min(min_sum, result)
            max_sum = max(max_sum, result)
        
        status = "✓" if negative_count == 0 else "✗"
        print(f"{status} N={N}: min={min_sum:8.2f}, max={max_sum:8.2f}, "
              f"negative={negative_count}/{n_trials}")
    
    print()
    return not counterexample_found


def test_boundary_cases():
    """Test boundary cases."""
    print("Boundary Cases:")
    print("=" * 70)
    
    test_cases = [
        ("All zeros (N=3)", [0, 0, 0]),
        ("Single nonzero (N=3)", [1, 0, 0]),
        ("Two equal (N=3)", [2, 2, 0]),
        ("Very small N=2", [1, 2]),
        ("Very small N=2 equal", [5, 5]),
    ]
    
    for name, u in test_cases:
        result = cyclic_sum(u)
        status = "✓" if result >= -1e-10 else "✗"
        print(f"{status} {name:25s}: sum = {result:10.6f}")
    
    print()


def main():
    print("=" * 70)
    print("Testing Cyclic Sum Inequality")
    print("Conjecture: ∑ᵢ uᵢ(u²ᵢ₋₂ - 4u²ᵢ₋₁ + 3u²ᵢ) ≥ 0 for all uᵢ ≥ 0")
    print("=" * 70)
    print()
    
    test_specific_examples()
    all_passed = test_random_examples(n_trials=100, max_n=6)
    test_boundary_cases()
    
    print("=" * 70)
    if all_passed:
        print("CONCLUSION: No counterexample found.")
        print("The inequality appears to be TRUE.")
    else:
        print("CONCLUSION: Counterexample(s) found!")
        print("The inequality is FALSE.")
    print("=" * 70)


if __name__ == "__main__":
    main()
