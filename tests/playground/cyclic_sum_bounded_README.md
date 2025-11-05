# Cyclic Sum Inequality with Bounded Reals

## Problem Statement

This file (`cyclic_sum_bounded.lean`) provides a formal translation in Lean 4 of the following mathematical problem:

**Given:**
- A natural number N
- Real numbers u_i for indices i between 1 and N, where 0 ≤ u_i ≤ 1
- Boundary conditions: u_0 = u_N and u_{-1} = u_{N-1}

**Claim:**
$$\sum_{i=1}^N u_i (u_{i-2}^2 - 4 u_{i-1}^2 + 3 u_i^2) \geq 0$$

## Differences from Other Formulations

This formulation differs from the other cyclic sum files in the playground:

1. **`cyclic_sum_inequality.lean`**: Uses different indices (u_{i-1}, u_i, u_{i+1} instead of u_{i-2}, u_{i-1}, u_i) and claims sum ≤ 0
2. **`cyclic_sum_proof.lean`**: Uses the same indices but with rationals instead of reals, and no bounded constraint

This file (`cyclic_sum_bounded.lean`) is the **exact translation** of the problem statement with:
- Real numbers (ℝ) as specified
- Bounded constraint: 0 ≤ u_i ≤ 1
- Correct indices: u_{i-2}, u_{i-1}, u_i
- Correct direction: sum ≥ 0

## File Contents

### Main Definitions

1. **`cyclicSumBounded`**: Computes the cyclic sum using Fin N indexing
   - Uses modular arithmetic for automatic boundary handling
   - Direct and efficient computation

2. **`cyclicSumBoundedNat`**: Alternative using natural number indexing
   - More explicit boundary conditions
   - Closer to the mathematical notation

### Main Theorems

1. **`cyclic_sum_bounded_inequality`**: Main theorem using Fin N
   ```lean
   theorem cyclic_sum_bounded_inequality (N : Nat) (hN : N > 0) (u : Fin N → ℝ)
       (bounded : ∀ i : Fin N, 0 ≤ u i ∧ u i ≤ 1) :
       0 ≤ cyclicSumBounded N u
   ```

2. **`cyclic_sum_bounded_inequality_nat`**: Alternative with explicit boundaries
   ```lean
   theorem cyclic_sum_bounded_inequality_nat (N : Nat) (hN : N > 0) (u : Nat → ℝ)
       (bounded : ∀ i : Nat, 1 ≤ i → i ≤ N → 0 ≤ u i ∧ u i ≤ 1)
       (boundary_0 : u 0 = u N)
       (boundary_minus_1 : u (N - 1) = cyclicAccess N u (-1)) :
       0 ≤ cyclicSumBoundedNat N u
   ```

### Examples

The file includes two concrete examples:

1. **`constantHalf`**: A sequence where all elements are 0.5
2. **`alternatingSeq`**: A sequence alternating between 0 and 1

These examples demonstrate:
- How to define sequences of bounded reals
- How to verify the bounded property
- How to apply the main theorem (once proved)

## Index Mapping

Understanding the index mapping is crucial:

| Problem Notation | Lean Fin N | Explanation |
|------------------|------------|-------------|
| u_1, ..., u_N | u 0, ..., u (N-1) | Lean uses 0-based indexing |
| u_0 = u_N | Automatic via modular arithmetic | Accessing index -1 wraps to N-1 |
| u_{-1} = u_{N-1} | Automatic via modular arithmetic | Accessing index -2 wraps to N-2 |

For element at Lean index `i`:
- `u i` corresponds to u_{i+1} in 1-based notation
- `u (i-1)` with wrapping corresponds to u_i in 1-based notation
- `u (i-2)` with wrapping corresponds to u_{i-1} in 1-based notation

## Cyclic Boundary Conditions

The boundary conditions from the problem statement are:
- u_0 = u_N: The value before the first element equals the last element
- u_{-1} = u_{N-1}: The value two positions before the first equals the second-to-last

With Fin N and modular arithmetic:
- These conditions are **automatically satisfied**
- No explicit assertions needed in the Fin-based formulation
- The natural number formulation makes them explicit for clarity

## Usage

To use this formulation:

1. **Define your sequence**:
   ```lean
   def mySeq : Fin N → ℝ := ...
   ```

2. **Prove it's bounded**:
   ```lean
   have bounded : ∀ i : Fin N, 0 ≤ mySeq i ∧ mySeq i ≤ 1 := by ...
   ```

3. **Apply the theorem**:
   ```lean
   have h := cyclic_sum_bounded_inequality N hN mySeq bounded
   -- h : 0 ≤ cyclicSumBounded N mySeq
   ```

## Current Status

⚠️ **Important**: The theorems use `sorry` as placeholders. This means:
- ✓ The formalization is syntactically correct
- ✓ The definitions are well-formed
- ✗ No actual proof is provided
- ✗ No counterexample is provided

The file **asks the question** in Lean's language but does not answer it. A proof or counterexample is needed.

## Next Steps

To complete this formulation:

1. **Prove the theorem**: Replace `sorry` with actual proofs showing the sum is non-negative
2. **Find a counterexample**: If the claim is false, provide a specific sequence where the sum is negative
3. **Add lemmas**: Break down the proof into smaller, manageable pieces
4. **Verify examples**: Compute the sum for the provided examples and verify they satisfy the inequality

## Verification

To check that the file compiles (requires Lean 4 installed):

```bash
cd tests/playground
lean cyclic_sum_bounded.lean
```

Expected output:
- Empty (success) or warnings about using 'sorry' (expected)
- No errors means the formalization is syntactically correct

## Mathematical Context

This inequality with the bounded constraint (0 ≤ u_i ≤ 1) is interesting because:
- The bounded constraint may make the inequality easier to prove
- It could be related to convexity or other optimization properties
- The specific form suggests connections to discrete calculus or variational methods

The coefficients (1, -4, 3) in the expression u_{i-2}^2 - 4u_{i-1}^2 + 3u_i^2 suggest this might be related to finite difference operators or discrete Laplacians.

## Related Files

- `cyclic_sum_inequality.lean`: Different formulation (different indices, ≤ 0)
- `cyclic_sum_proof.lean`: Same indices but using rationals
- `cyclic_sum_minimal.lean`: Minimal example of similar problem
- `cyclic_sum_examples.lean`: Various example sequences
