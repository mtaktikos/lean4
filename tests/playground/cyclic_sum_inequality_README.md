# Cyclic Sum Inequality - Lean 4 Formulation

## Problem Statement

This file contains a formulation in Lean 4 of the following mathematical inequality problem:

**Given:**
- A natural number N > 0
- A sequence u[i] for i from 1 to N, where all u[i] ≠ 0
- Boundary conditions: u[0] = u[N] and u[N+1] = u[1]

**Claim:**
```
Sum[u[i]*(u[i-1]^2 - 4*u[i]^2 + 3*u[i+1]^2), {i, 1, N}] ≤ 0
```

## File Structure

The file `cyclic_sum_inequality.lean` contains:

### Core Definitions

1. **`cyclicIndex`**: Maps integer indices to natural numbers with cyclic wrapping
2. **`cyclicAt`**: Accesses a sequence at a cyclic index
3. **`sumTerm`**: Computes a single term in the sum: `u[i]*(u[i-1]^2 - 4*u[i]^2 + 3*u[i+1]^2)`
4. **`cyclicSum`**: Computes the full sum from i=1 to N
5. **`cyclicSumFin`**: Alternative formulation using `Fin N` for more type-safe indexing

### Main Theorems

1. **`cyclic_sum_inequality`**: States that the cyclic sum is ≤ 0 for sequences with the given properties
2. **`cyclic_sum_inequality_fin`**: Alternative formulation using `Fin N` indexing

## How to Use

### Approach 1: Using Natural Number Indexing

```lean
theorem cyclic_sum_inequality (N : Nat) (hN : N > 0) (u : Nat → ℚ) 
    (nonzero : ∀ i : Nat, 1 ≤ i → i ≤ N → u i ≠ 0)
    (boundary_0 : cyclicAt N u 0 = cyclicAt N u N)
    (boundary_N_plus_1 : cyclicAt N u (N + 1) = cyclicAt N u 1) :
    cyclicSum N u ≤ 0
```

This approach:
- Uses a function `u : Nat → ℚ` for the sequence
- Requires explicit boundary conditions
- Suitable when you have a naturally-indexed sequence

### Approach 2: Using Fin Indexing

```lean
theorem cyclic_sum_inequality_fin (N : Nat) (hN : N > 0) (u : Fin N → ℚ) 
    (nonzero : ∀ i : Fin N, u i ≠ 0) :
    cyclicSumFin N u ≤ 0
```

This approach:
- Uses a function `u : Fin N → ℚ` for the sequence
- Cyclic boundary conditions are implicit via modular arithmetic
- More type-safe and concise
- Recommended for most use cases

## Implementation Notes

### Type Choice: Rationals (ℚ)

The formulation uses rational numbers (ℚ) rather than reals because:
1. Rationals are computable and have decidable equality
2. The inequality works for any ordered field
3. More practical for formal verification in Lean

If you need to work with real numbers instead, you can adapt the definitions by replacing `ℚ` with `ℝ` (though this would require importing additional libraries for real numbers).

### Cyclic Indexing

The cyclic boundary conditions are handled in two ways:

1. **Explicit approach** (`cyclicAt`): Uses modular arithmetic to wrap indices
2. **Fin-based approach** (`cyclicSumFin`): Uses `Fin N` with built-in modular arithmetic

### Proof Strategy

The theorems are stated with `sorry` placeholders. To prove the inequality, you would need to:

1. Expand the sum algebraically
2. Group and rearrange terms
3. Complete the square or use other algebraic techniques
4. Show that the resulting expression is ≤ 0

## Example Usage

To verify that a specific sequence satisfies the inequality:

```lean
-- Define a specific sequence
def mySequence : Fin 3 → ℚ
  | ⟨0, _⟩ => 1
  | ⟨1, _⟩ => 2
  | ⟨2, _⟩ => 1
  | ⟨_, h⟩ => absurd h (Nat.not_lt_of_le (Nat.le_refl 3))

-- Verify properties
example : ∀ i : Fin 3, mySequence i ≠ 0 := by
  intro i
  fin_cases i <;> norm_num [mySequence]

-- Check the inequality (would need proof)
example : cyclicSumFin 3 mySequence ≤ 0 := by
  sorry
```

## Running the Files

To check that the file compiles correctly (assuming Lean 4 is installed):

```bash
lean cyclic_sum_inequality.lean
```

**Expected output**: Warnings about using 'sorry' (this is normal - it means the formalization is correct but proofs are incomplete).

See `README_RUN_LEAN.md` for detailed instructions on:
- How to install Lean 4
- How to run all the files
- What output to expect
- What the warnings mean

**Important**: The files compile successfully, but they do NOT provide formal proofs. They use `sorry` to admit the theorems without proving them. The formalization is complete, but the verification is not.

## Next Steps

To complete this formulation:

1. **Prove the theorem**: Replace `sorry` with actual proofs
2. **Add lemmas**: Break down the proof into smaller, manageable lemmas
3. **Provide examples**: Show concrete instances where the inequality holds
4. **Generalize**: Consider whether the result holds for other coefficient patterns

## Mathematical Context

This type of inequality often appears in:
- Optimization problems
- Discrete calculus
- Analysis of periodic sequences
- Physics (e.g., stability analysis)

The specific coefficients (1, -4, 3) in the expression `u[i-1]^2 - 4*u[i]^2 + 3*u[i+1]^2` suggest this might be related to a discrete Laplacian or similar operator.
