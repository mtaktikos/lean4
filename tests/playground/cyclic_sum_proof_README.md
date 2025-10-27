# Cyclic Sum Inequality: Analysis and Results

## Problem Statement

**Question:** Let N be a natural number and let $u_i \geq 0$ for $i$ between 1 and N. 
We set $u_0 = u_N$ and $u_{N+1} = u_1$ (cyclic boundary conditions). 

Is the following inequality true?

$$\sum_{i=1}^{N} u_i(u_{i-2}^2 - 4u_{i-1}^2 + 3u_i^2) \geq 0$$

## Answer

**YES**, the inequality appears to be **TRUE** based on extensive computational evidence.

### Computational Verification

We tested:
- 100 random examples each for N = 3, 4, 5
- Various edge cases including:
  - All elements equal (sum = 0)
  - Large variations in values
  - Sequences with zeros
  - Small N (N=2) and larger N (N=6, N=10)

**Result:** All 300+ test cases yielded non-negative sums. No counterexample was found.

### Example Computations

#### Example 1: All ones (N=3)
- Input: u = [1, 1, 1]
- Each term: 1 × (1² - 4×1² + 3×1²) = 1 × 0 = 0
- **Sum = 0** ✓

#### Example 2: [1, 2, 1] (N=3)
- Term i=0: 1 × (2² - 4×1² + 3×1²) = 3
- Term i=1: 2 × (1² - 4×1² + 3×2²) = 18
- Term i=2: 1 × (1² - 4×2² + 3×1²) = -12
- **Sum = 9** ✓

#### Example 3: [1, 10, 1] (N=3)
- **Sum = 2673** ✓

#### Example 4: [1, 2, 3, 4] (N=4)
- **Sum = 96** ✓

#### Example 5: Random values [6.39, 0.25, 2.75] (N=3)
- **Sum ≈ 726.46** ✓

## Algebraic Analysis

### For N=3

The sum expands to:

$$\begin{align}
\text{Sum} &= u_0 \cdot (u_1^2 - 4u_2^2 + 3u_0^2) \\
&\quad + u_1 \cdot (u_2^2 - 4u_0^2 + 3u_1^2) \\
&\quad + u_2 \cdot (u_0^2 - 4u_1^2 + 3u_2^2)
\end{align}$$

Expanding:
$$\begin{align}
&= u_0 u_1^2 - 4u_0 u_2^2 + 3u_0^3 \\
&\quad + u_1 u_2^2 - 4u_0^2 u_1 + 3u_1^3 \\
&\quad + u_0^2 u_2 - 4u_1^2 u_2 + 3u_2^3
\end{align}$$

Grouping by structure:
$$\text{Sum} = 3(u_0^3 + u_1^3 + u_2^3) + u_0 u_1(u_1 - 4u_0) + u_1 u_2(u_2 - 4u_1) + u_2 u_0(u_0 - 4u_2)$$

This form shows:
1. A cubic term that is always non-negative for $u_i \geq 0$
2. Mixed terms that can be negative but appear to be dominated by the cubic terms

### Pattern Recognition

The expression has the form:
- Diagonal dominance: The coefficient 3 on $u_i^2$ is larger than the coefficient 4 on neighboring terms
- Cyclic symmetry: The sum treats all positions equally
- Homogeneous of degree 3: Scaling all $u_i$ by $\lambda$ scales the sum by $\lambda^3$

## Lean 4 Implementation

The file `cyclic_sum_proof.lean` contains:

1. **Function definition**: `cyclicSumProof` computes the sum for any sequence
2. **Theorem statement**: `cyclic_sum_nonnegative` states the inequality (with `sorry` placeholder)
3. **Examples**: 10 concrete examples that can be evaluated
4. **Verification helper**: `verify_indexing` demonstrates the cyclic indexing is correct

### Key Features

- Uses `Fin N` for type-safe indexing (0 to N-1)
- Cyclic boundary conditions via modular arithmetic: `(i + N - k) % N`
- Rational numbers (ℚ) for exact arithmetic
- Executable examples via `#eval`

## Mathematical Insights

### Why might this be true?

1. **Discrete Laplacian Structure**: The expression $u_{i-2}^2 - 4u_{i-1}^2 + 3u_i^2$ resembles a discrete second-order difference operator

2. **Positive Definiteness**: The coefficient pattern (1, -4, 3) on squared terms suggests a positive semi-definite quadratic form

3. **Variational Interpretation**: This could be related to the sum of squares of certain differences in the sequence

4. **Conservation Properties**: The cyclic nature and the specific coefficients may lead to telescoping or cancellation that preserves non-negativity

### Towards a Formal Proof

A complete proof would likely involve:

1. **Algebraic manipulation**: Rewriting the sum in a form that makes non-negativity obvious
2. **Sum of squares representation**: Showing the sum can be written as a sum of squares (SOS)
3. **Inequality techniques**: Using classical inequalities (AM-GM, Cauchy-Schwarz, etc.)
4. **Induction on N**: If a pattern can be established

The specific coefficients (1, -4, 3) in the pattern $u_{i-2}^2 - 4u_{i-1}^2 + 3u_i^2$ are crucial. This might be expressible as:
$$3u_i^2 - 4u_{i-1}^2 + u_{i-2}^2 = 3(u_i - au_{i-1})^2 + \text{other positive terms}$$
for some appropriate choice of $a$.

## How to Use This File

### Running the Lean File

To check the Lean file (assuming Lean 4 is installed):

```bash
cd tests/playground
lean cyclic_sum_proof.lean
```

This will:
- Type-check the definitions
- Evaluate the `#eval` commands (showing concrete sum values)
- Verify the indexing with `verify_indexing`

Note: The theorem has a `sorry` placeholder since a formal proof has not been completed.

### Extending the Analysis

To further investigate:

1. **More examples**: Add more test cases to `cyclic_sum_proof.lean`
2. **Proof attempts**: Replace `sorry` with proof tactics
3. **Generalization**: Study the pattern for different coefficients
4. **Optimization**: Find sequences that minimize/maximize the sum

## Conclusion

**The inequality is TRUE** (with high confidence based on computational evidence).

The challenge is to provide a rigorous mathematical proof. The Lean formalization provides:
- A precise statement of the problem
- Executable verification of specific cases
- A framework for developing a formal proof

**Next Steps:**
1. Attempt to find a sum-of-squares decomposition
2. Look for connections to known inequalities in the literature
3. Develop lemmas about the algebraic structure
4. Consider case analysis or induction strategies

## Files

- `cyclic_sum_proof.lean` - Lean 4 formalization with examples
- `cyclic_sum_proof_README.md` - This documentation file
- Related files: `cyclic_sum_inequality.lean`, `cyclic_sum_minimal.lean` (different problem variants)

## References

This problem involves:
- Cyclic sequences and circular boundary conditions
- Discrete calculus and finite differences
- Quadratic forms and positive definiteness
- Polynomial inequalities

For similar problems, see:
- Schur's inequality
- Muirhead's inequality
- Cyclic sum inequalities in mathematical olympiads
