# Divergence in a Collatz-Type Recursion - Lean 4 Formalization

This directory contains a formalization in Lean 4 of the divergence theorem for a Collatz-type recursion, based on the paper "Divergence in a Collatz-Type Recursion" by Ingo Althöfer and Thomas Zipproth (September 8, 2025).

## Paper Summary

The paper studies a generalization of the famous Collatz conjecture. While the classical Collatz recursion maps odd `n` to `3n + 1` (and then repeatedly halves), this work considers:

```
T(n) = ⌊√2·n + 4⌋ / 2^(ν₂(⌊√2·n + 4⌋))
```

where:
- `ν₂(m)` counts the number of times 2 divides `m` (trailing zeros in binary)
- The operation takes an affine step `√2·n + 4`, then divides out all powers of 2

**Main Result (Theorem 1):** For this specific recursion with parameters (√2, 4), every odd starting value leads to a diverging sequence. This is in stark contrast to the Collatz conjecture, which predicts that all orbits eventually reach the cycle 1 → 4 → 2 → 1.

## File Structure

### `DivergenceTheorem.lean`

The Lean formalization contains:

1. **Core Definitions**
   - `nu2 n` - counts how many times 2 divides n (ν₂ function)
   - `floorSqrt2Times n` - computes ⌊√2·n⌋ using rational approximation (1393/985)
   - `T n` - the main recursion function
   - `orbit n0 t` - computes the t-th term of the orbit starting at n₀

2. **Helper Functions** (matching the paper's notation)
   - `k n` - equals ⌊√2·n⌋
   - `R n` - equals k(n) + 4
   - `e n` - equals ν₂(R(n)), the number of halvings in one step

3. **Key Predicates**
   - `isOdd n` - n is odd
   - `invariant n` - the invariant I(n): k(n) ≢ 0 (mod 4)
   - `kIsOdd n`, `kMod2_4 n`, `kMod0_4 n` - properties of k(n) modulo 4

4. **Main Lemmas** (with proof obligations marked with `sorry`)
   
   **Lemma 1** - Transition properties:
   - If k(n) is odd, then e(n) = 0 and T(n) = k(n) + 4
   - If k(n) ≡ 2 (mod 4), then e(n) = 1 and T(n) = (k(n) + 4)/2
   
   **Lemma 2** - Persistence of the invariant:
   - Starting from n₀ = 1, the invariant I(nₜ) holds for all t ≥ 0
   - This ensures we never have k(nₜ) ≡ 0 (mod 4) after initialization
   
   **Lemma 3** - End of multi-halving:
   - If k(nₜ) ≡ 0 (mod 4), then nₜ₊₁ ≤ nₜ/√8 + 1
   - Consecutive multi-halving steps terminate in O(log n₀) steps

5. **Main Theorem** - Divergence:
   - After an initial phase of O(log n₀) steps, either nₜ₊₁ > nₜ or nₜ₊₂ > nₜ
   - Therefore, the sequence cannot be bounded and diverges to infinity
   - Corollary: No finite limit cycles exist that capture all orbits

6. **Computational Examples**
   - Verification of the first terms of the orbit starting at n₀ = 1
   - Growth pattern checker to observe divergence behavior

## Mathematical Background

### The √2 Approximation

The formalization uses the rational approximation 1393/985 for √2, which gives:
- √2 ≈ 1.41421319796...
- True value: √2 ≈ 1.41421356237...
- Error: ~0.00000036 per multiplication

This convergent (from the continued fraction of √2) provides sufficient accuracy for the theoretical results while maintaining computational tractability in Lean.

### Key Insight

The paper proves that the recursion never halves twice in a row (after initialization), and each step either:
1. Increases immediately: nₜ₊₁ > nₜ (when no halving occurs)
2. Increases after two steps: nₜ₊₂ > nₜ (when one halving occurs at step t)

This "two-step drift" ensures divergence.

## How to Use

To verify this formalization once Lean 4 is built:

```bash
# From the lean4 repository root
./bin/lean tests/playground/ingo251116/DivergenceTheorem.lean
```

Or to compile to an executable:

```bash
cd tests/playground/ingo251116
../compile.sh DivergenceTheorem.lean
./DivergenceTheorem.lean.out
```

## Current Status

The file provides a complete **structure** for the formalization with:
- ✅ All definitions implemented and computable
- ✅ All theorem statements properly formulated
- ✅ Comprehensive documentation matching the paper
- ✅ Computational examples that can be evaluated
- ⏳ Formal proofs marked with `sorry` (to be completed)

The proof obligations are clearly marked and organized to guide future formalization work.

## Future Work

To complete the formalization:

1. **Prove basic properties of nu2**
   - Relationship with even/odd numbers
   - Computation rules

2. **Prove Lemma 1** 
   - Requires reasoning about √2 arithmetic
   - May need additional lemmas about the rational approximation

3. **Prove Lemma 2**
   - Inductive proof using Lemma 1
   - Track the invariant through the recursion

4. **Prove Lemma 3**
   - Arithmetic bound on the multi-halving case

5. **Prove Main Theorem**
   - Combine all lemmas
   - Proof by contradiction for unboundedness

## References

- Ingo Althöfer and Thomas Zipproth. "Divergence in a Collatz-Type Recursion." September 8, 2025.
- The original Collatz conjecture: J. Lagarias. "The 3x + 1 problem and its generalizations." American Mathematical Monthly 92 (1985), 3–23.

## Notes

This is a **counterexample** to the natural generalization that all Collatz-type recursions eventually enter finite limit cycles. The choice of (√2, 4) as parameters creates a system where the irrational nature of √2 ensures perpetual growth rather than cycling.
