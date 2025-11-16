# Proof Guide for Completing the Formalization

This guide provides suggestions for completing the formal proofs in `DivergenceTheorem.lean`. The proofs are currently marked with `sorry` but the structure is in place.

## Proof Strategy Overview

The main theorem (divergence) follows from a sequence of lemmas, building from basic properties to the final result. Here's the dependency chain:

```
Basic Properties (nu2, modular arithmetic)
    ↓
Lemma 1 (transition properties)
    ↓
Lemma 2 (invariant persistence) ← uses Lemma 1
    ↓
Lemma 3 (end of multi-halving)
    ↓
Main Theorem (divergence) ← uses Lemmas 2 & 3
```

## Level 1: Basic Properties (Easiest)

### 1.1 Properties of `nu2`

**Goal**: Prove basic facts about the ν₂ function.

```lean
theorem nu2_zero : nu2 0 = 0
```
**Approach**: Direct from definition, already in place.

```lean
theorem nu2_odd (n : Nat) (h : n % 2 = 1) (h_pos : n > 0) : nu2 n = 0
```
**Approach**: Unfold definition, use case analysis.

```lean
theorem nu2_even (n : Nat) (h : n % 2 = 0) (h_pos : n > 0) : 
  nu2 n = 1 + nu2 (n / 2)
```
**Approach**: Unfold definition, use the recursive case.

**Additional useful lemmas** (not yet in file):
```lean
-- Power of 2 division
theorem nu2_mul_pow2 (n k : Nat) : nu2 (n * 2^k) = nu2 n + k

-- Relationship to divisibility
theorem nu2_div (n : Nat) (h : nu2 n = k) : 2^k ∣ n ∧ ¬(2^(k+1) ∣ n)
```

### 1.2 Modular Arithmetic Properties

```lean
theorem odd_not_even (n : Nat) : isOdd n ↔ ¬isEven n
```
**Approach**: Use `n % 2` properties: `n % 2 ∈ {0, 1}` for all n.

```lean
theorem e_from_k_odd (n : Nat) (h : kIsOdd n) : e n = 0
theorem e_from_k_mod2 (n : Nat) (h : kMod2_4 n) : e n = 1
theorem e_from_k_mod0 (n : Nat) (h : kMod0_4 n) : e n ≥ 2
```
**Approach**: 
- Use definitions: `e n = nu2 (R n) = nu2 (k n + 4)`
- Case analysis on `k n % 4`:
  - If `k n ≡ 1 (mod 4)`, then `k n + 4 ≡ 5 ≡ 1 (mod 4)` → odd → `nu2 = 0`
  - If `k n ≡ 3 (mod 4)`, then `k n + 4 ≡ 7 ≡ 3 (mod 4)` → odd → `nu2 = 0`
  - If `k n ≡ 2 (mod 4)`, then `k n + 4 ≡ 6 ≡ 2 (mod 4)` → divisible by 2 once → `nu2 = 1`
  - If `k n ≡ 0 (mod 4)`, then `k n + 4 ≡ 4 ≡ 0 (mod 4)` → divisible by 4 → `nu2 ≥ 2`

## Level 2: Lemma 1 (Moderate)

**Goal**: Prove transition properties of the recursion.

### Part 1: Odd case

```lean
theorem lemma1_part1 (n : Nat) (h_odd : isOdd n) (h_k_odd : kIsOdd n) :
  e n = 0 ∧ T n = k n + 4
```

**Approach**:
1. Use `e_from_k_odd` to show `e n = 0`
2. Unfold `T n = R n / 2^(e n) = R n / 2^0 = R n = k n + 4`

### Part 2: Mod 2 case

```lean
theorem lemma1_part2 (n : Nat) (h_odd : isOdd n) (h_k_mod2 : kMod2_4 n) :
  e n = 1 ∧ T n = (k n + 4) / 2
```

**Approach**:
1. Use `e_from_k_mod2` to show `e n = 1`
2. Unfold `T n = R n / 2^1 = (k n + 4) / 2`

### Part 1 Extended: Range of k(T(n))

```lean
theorem lemma1_part1_range (n : Nat) (h_odd : isOdd n) (h_k_odd : kIsOdd n) :
  let t := T n
  k t = 2*n + 4 ∨ k t = 2*n + 5
```

**Approach**:
1. From part 1: `T n = k n + 4`
2. Need: `k(T n) = k(k n + 4) = ⌊√2(k n + 4)⌋`
3. Use: `k n = ⌊√2 n⌋`, so `k n ≈ √2 n`
4. Thus: `k(T n) ≈ ⌊√2(√2 n + 4)⌋ = ⌊2n + 4√2⌋`
5. Since `√2 ≈ 1.414`, we have `4√2 ≈ 5.656`
6. So `k(T n) ∈ {2n + 4, 2n + 5}` (depends on fractional part)

**Challenge**: This requires careful reasoning about the rational approximation of √2 and how rounding behaves. May need additional lemmas about `floorSqrt2Times`.

## Level 3: Lemma 2 (Moderate to Hard)

**Goal**: Prove invariant persistence along orbits starting from 1.

```lean
theorem lemma2_base : invariant 1
```
**Approach**:
- Compute: `k 1 = ⌊√2 · 1⌋ = 1`
- Check: `1 % 4 = 1 ≠ 0` ✓

```lean
theorem lemma2_inductive (n : Nat) (h_odd : isOdd n) (h_inv : invariant n) :
  invariant (T n)
```
**Approach**: Case analysis on `k n % 4`:

**Case 1**: `k n ≡ 1 (mod 4)` (odd)
- By Lemma 1 part 1: `T n = k n + 4`
- By Lemma 1 extended: `k(T n) ∈ {2n + 4, 2n + 5}`
- Both are `≡ 0, 1 (mod 4)` or `≡ 1, 2 (mod 4)` depending on n's parity
- Need to show neither is `≡ 0 (mod 4)`
- This requires careful arithmetic modulo 4

**Case 2**: `k n ≡ 3 (mod 4)` (odd)
- Similar to Case 1

**Case 3**: `k n ≡ 2 (mod 4)`
- By Lemma 1 part 2: `T n = (k n + 4) / 2`
- By Lemma 1 extended: `k(T n) = n + 2`
- Since n is odd, `n + 2` is odd
- Odd numbers are never `≡ 0 (mod 4)` ✓

**Case 4**: `k n ≡ 0 (mod 4)`
- This contradicts `invariant n`, so this case is vacuous

```lean
theorem lemma2 (t : Nat) : invariant (orbit 1 t)
```
**Approach**: Induction on t
- Base: `lemma2_base`
- Step: Use `lemma2_inductive`

## Level 4: Lemma 3 (Moderate)

**Goal**: Bound growth in the multi-halving case.

```lean
theorem lemma3 (n : Nat) (h_k_mod0 : kMod0_4 n) :
  T n ≤ n / 4 + 1
```

**Approach**:
1. From hypothesis: `k n % 4 = 0`, so `k n = 4m` for some m
2. We have `k n ≈ √2 n`, so `n ≈ k n / √2`
3. `R n = k n + 4 = 4m + 4 = 4(m + 1)`
4. `e n = nu2(4(m + 1)) ≥ 2`
5. `T n = R n / 2^(e n) ≤ R n / 4 = (k n + 4) / 4`
6. `T n ≤ (√2 n + 4) / 4 = n/√8 + 1 ≤ n/2.8 + 1 < n/2 + 1`

For the paper's bound `n/√8 + 1`, use `√8 = 2√2 ≈ 2.828`, giving `n/√8 ≈ n/2.828`.

## Level 5: Main Theorem (Hard)

### Part 1: Growth property

```lean
theorem main_theorem_growth (n0 : Nat) (h_odd : isOdd n0) :
  ∃ T_init : Nat, ∀ t : Nat, t ≥ T_init →
    (orbit n0 (t + 1) > orbit n0 t ∨ orbit n0 (t + 2) > orbit n0 t)
```

**Approach**:
1. Use Lemma 3 to show multi-halving phase ends in O(log n₀) steps
2. After that phase, by Lemma 2, invariant holds, so `e ∈ {0, 1}`
3. Case analysis:
   - **e = 0**: No halving, so `T n = k n + 4 > n` (since `k n ≈ √2 n > n` for n ≥ 3)
   - **e = 1**: One halving, `T n = (k n + 4)/2 ≈ (√2 n + 4)/2`
     - May decrease initially
     - But `T(T n)` increases because by Lemma 1, next step has `e = 0`
     - Show `T(T n) > n` using `T n ≈ n/√2 + 2` and `T(T n) ≈ √2(n/√2 + 2) + 4 = n + 2√2 + 4 > n`

### Part 2: Unboundedness

```lean
theorem main_theorem_unbounded (n0 : Nat) (h_odd : isOdd n0) (h_pos : n0 > 0) :
  ∀ M : Nat, ∃ t : Nat, orbit n0 t > M
```

**Approach**: Proof by contradiction
1. Assume bounded: `∃ B, ∀ t, orbit n0 t ≤ B`
2. By growth property, after T_init, always increase in 1 or 2 steps
3. If sequence visits maximum value `B` at time `t₀ ≥ T_init`
4. Then either `orbit n0 (t₀ + 1) > B` or `orbit n0 (t₀ + 2) > B`
5. Contradiction with boundedness ✗

## Recommended Proving Order

1. **Start simple**: Prove `nu2` properties, modular arithmetic facts
2. **Build up**: Prove `e_from_k_*` lemmas connecting definitions
3. **Tackle Lemma 1**: Parts 1 and 2 first, then extended versions
4. **Prove Lemma 2**: Base case is computational, inductive step uses Lemma 1
5. **Prove Lemma 3**: Arithmetic inequality
6. **Combine for Main Theorem**: Use all previous lemmas

## Useful Lean Tactics

- `unfold` - expand definitions
- `simp` - simplify using basic lemmas
- `split` - case analysis on if-then-else or match
- `omega` - solve linear arithmetic
- `norm_num` - normalize numeric expressions
- `ring` - solve ring equations
- `calc` - step-by-step calculation proofs
- `induction` - for recursive definitions and sequences
- `contradiction` - when assumptions are inconsistent
- `by_contra` - proof by contradiction

## Additional Lemmas You Might Need

```lean
-- Relationship between k and √2
theorem k_lower_bound (n : Nat) : k n ≥ n  -- for n ≥ 2, since √2 > 1
theorem k_upper_bound (n : Nat) : k n ≤ 2*n  -- since √2 < 2

-- Growth when no halving
theorem T_grows_no_halving (n : Nat) (h : e n = 0) (h_n : n ≥ 3) : T n > n

-- Two-step growth with halving
theorem T_T_grows_with_halving (n : Nat) (h : e n = 1) (h_n : n ≥ 3) : T (T n) > n

-- Orbit growth after initialization
theorem orbit_eventually_grows (n0 : Nat) (h : n0 ≥ 3) (h_odd : isOdd n0) :
  ∃ T_init, ∀ t ≥ T_init, orbit n0 t ≥ n0
```

## Notes on the √2 Approximation

The rational approximation 1393/985 should be accurate enough for theoretical proofs. However, you may need to:

1. **Add lemmas** about the approximation error:
   ```lean
   theorem sqrt2_approx_error (n : Nat) :
     |floorSqrt2Times n - Real.floor (Real.sqrt 2 * n)| ≤ 1
   ```

2. **Work with ranges** rather than exact values:
   ```lean
   theorem k_range (n : Nat) : 
     Real.floor (Real.sqrt 2 * n) - 1 ≤ k n ∧ 
     k n ≤ Real.floor (Real.sqrt 2 * n) + 1
   ```

3. **Prove robustness**: Show that ±1 errors don't affect the main results.

## Getting Help

If you get stuck:
- Check the Lean Zulip chat: https://leanprover.zulipchat.com/
- Look at similar formalizations in Mathlib
- Refer to "Theorem Proving in Lean 4": https://lean-lang.org/theorem_proving_in_lean4/
- Study the paper proofs carefully for mathematical insights

Good luck with completing the formalization! 🎯
