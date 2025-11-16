/-
  Divergence in a Collatz-Type Recursion
  
  This file formalizes the result from "Divergence in a Collatz-Type Recursion"
  by Ingo Althöfer and Thomas Zipproth (September 8, 2025).
  
  Main Result: For the recursion T(n) = ⌊√2·n + 4⌋ / 2^(ν₂(⌊√2·n + 4⌋)),
  every odd starting value n₀ leads to a diverging sequence.
-/

namespace CollatzDivergence

/- 
  Helper: ν₂(n) counts the number of times 2 divides n 
  (equivalently, the number of trailing zeros in binary representation)
-/
def nu2 (n : Nat) : Nat :=
  if h : n = 0 then 0
  else if n % 2 = 0 then 1 + nu2 (n / 2)
  else 0
termination_by n

/- 
  Floor of √2 * n using a high-precision rational approximation.
  √2 ≈ 1.41421356237...
  
  We use the convergent 1393/985 which gives √2 ≈ 1.41421319796...
  This is accurate to about 8 decimal places and is one of the best
  rational approximations with denominator < 1000.
  
  For even better precision, we could use 665857/470832 ≈ 1.41421356237...
-/
def floorSqrt2Times (n : Nat) : Nat :=
  (1393 * n) / 985

-- The recursion function T(n) = ⌊√2·n + 4⌋ / 2^(ν₂(⌊√2·n + 4⌋))
def T (n : Nat) : Nat :=
  let r := floorSqrt2Times n + 4
  let e := nu2 r
  r / (2 ^ e)

-- k(n) = ⌊√2·n⌋
def k (n : Nat) : Nat :=
  floorSqrt2Times n

-- R(n) = k(n) + 4
def R (n : Nat) : Nat :=
  k n + 4

-- e(n) = ν₂(R(n))
def e (n : Nat) : Nat :=
  nu2 (R n)

-- Alternative definition of T using the helper functions
def T' (n : Nat) : Nat :=
  R n / (2 ^ (e n))

-- Verify T and T' are equivalent
theorem T_eq_T' (n : Nat) : T n = T' n := by
  unfold T T' R e k floorSqrt2Times
  rfl

-- Basic properties of nu2
theorem nu2_zero : nu2 0 = 0 := by
  unfold nu2
  simp

theorem nu2_odd (n : Nat) (h : n % 2 = 1) (h_pos : n > 0) : nu2 n = 0 := by
  sorry

theorem nu2_even (n : Nat) (h : n % 2 = 0) (h_pos : n > 0) : 
  nu2 n = 1 + nu2 (n / 2) := by
  sorry

-- Predicate: n is odd
def isOdd (n : Nat) : Prop :=
  n % 2 = 1

-- The invariant I(n): k(n) ≢ 0 (mod 4)
def invariant (n : Nat) : Prop :=
  k n % 4 ≠ 0

-- Property: k(n) is odd
def kIsOdd (n : Nat) : Prop :=
  k n % 2 = 1

-- Property: k(n) ≡ 2 (mod 4)
def kMod2_4 (n : Nat) : Prop :=
  k n % 4 = 2

-- Property: k(n) ≡ 0 (mod 4)
def kMod0_4 (n : Nat) : Prop :=
  k n % 4 = 0

-- Generate orbit sequence
def orbit (n0 : Nat) : Nat → Nat
  | 0 => n0
  | t + 1 => T (orbit n0 t)

-- Helper: check if a number is even
def isEven (n : Nat) : Prop :=
  n % 2 = 0

-- Relationship between odd and even
theorem odd_not_even (n : Nat) : isOdd n ↔ ¬isEven n := by
  sorry

-- Properties relating k, R, e, and T
theorem e_cases (n : Nat) : e n = 0 ∨ e n = 1 ∨ e n ≥ 2 := by
  sorry

theorem e_from_k_odd (n : Nat) (h : kIsOdd n) : e n = 0 := by
  sorry

theorem e_from_k_mod2 (n : Nat) (h : kMod2_4 n) : e n = 1 := by
  sorry

theorem e_from_k_mod0 (n : Nat) (h : kMod0_4 n) : e n ≥ 2 := by
  sorry

/-
  Lemma 1: Transition of ⌊√2·T(n)⌋
  
  This lemma describes how ⌊√2·T(n)⌋ behaves based on whether k(n) is odd or ≡ 2 (mod 4).
  
  Part 1: If k(n) is odd, then e(n) = 0 and T(n) = k(n) + 4, which means
          √2·T(n) ∈ (2n + 4.242..., 2n + 5.656...),
          hence ⌊√2·T(n)⌋ ∈ {2n + 4, 2n + 5} (≡ 2, 3 (mod 4)).
  
  Part 2: If k(n) ≡ 2 (mod 4), then e(n) = 1 and T(n) = (k(n) + 4)/2, which means
          √2·T(n) ∈ (n + 2.121..., n + 2.828...),
          hence ⌊√2·T(n)⌋ = n + 2 (odd).
-/
theorem lemma1_part1 (n : Nat) (h_odd : isOdd n) (h_k_odd : kIsOdd n) :
  e n = 0 ∧ T n = k n + 4 := by
  sorry

theorem lemma1_part2 (n : Nat) (h_odd : isOdd n) (h_k_mod2 : kMod2_4 n) :
  e n = 1 ∧ T n = (k n + 4) / 2 := by
  sorry

theorem lemma1_part1_range (n : Nat) (h_odd : isOdd n) (h_k_odd : kIsOdd n) :
  let t := T n
  k t = 2*n + 4 ∨ k t = 2*n + 5 := by
  sorry

theorem lemma1_part2_exact (n : Nat) (h_odd : isOdd n) (h_k_mod2 : kMod2_4 n) :
  k (T n) = n + 2 := by
  sorry

/-
  Lemma 2: Persistence of the invariant
  
  Along the orbit starting at n₀ = 1, the invariant I(nₜ) holds for all t ≥ 0.
-/
theorem lemma2_base : invariant 1 := by
  sorry

theorem lemma2_inductive (n : Nat) (h_odd : isOdd n) (h_inv : invariant n) :
  invariant (T n) := by
  sorry

theorem lemma2 (t : Nat) : invariant (orbit 1 t) := by
  sorry

/-
  Lemma 3: End of multi-halving
  
  If k(nₜ) ≡ 0 (mod 4), then nₜ₊₁ ≤ nₜ/√8 + 1, which ensures that consecutive
  multi-halving steps terminate in O(log n₀) steps.
-/
theorem lemma3 (n : Nat) (h_k_mod0 : kMod0_4 n) :
  T n ≤ n / 4 + 1 := by
  sorry

/-
  Main Theorem: Divergence (Theorem 1 from the paper)
  
  For the recursion T(n) = ⌊√2·n + 4⌋ / 2^(ν₂(⌊√2·n + 4⌋)) and every odd starting 
  value n₀, the sequence (nₜ)ₜ≥₀ with nₜ₊₁ = T(nₜ) is unbounded.
  
  More precisely, there exists T_init = O(log n₀) such that for all t ≥ T_init
  either nₜ₊₁ > nₜ or nₜ₊₂ > nₜ.
-/
theorem main_theorem_growth (n0 : Nat) (h_odd : isOdd n0) :
  ∃ T_init : Nat, ∀ t : Nat, t ≥ T_init →
    (orbit n0 (t + 1) > orbit n0 t ∨ orbit n0 (t + 2) > orbit n0 t) := by
  sorry

theorem main_theorem_unbounded (n0 : Nat) (h_odd : isOdd n0) (h_pos : n0 > 0) :
  ∀ M : Nat, ∃ t : Nat, orbit n0 t > M := by
  sorry

/-
  Corollary: No finite limit cycles
  
  As a consequence of divergence, this recursion has no finite limit cycles
  that capture all orbits (starting from odd values).
-/
theorem no_finite_cycles (n0 : Nat) (h_odd : isOdd n0) (h_pos : n0 > 0) :
  ∀ cycle : List Nat, cycle ≠ [] → 
    ¬(∀ t : Nat, ∃ i : Nat, i < cycle.length ∧ orbit n0 t = cycle[i]!) := by
  sorry

/-
  Properties from the paper
  
  The paper establishes that e(n) depends on k(n) mod 4:
  - e(n) = 0 if k(n) ≡ 1, 3 (mod 4) [k(n) is odd]
  - e(n) = 1 if k(n) ≡ 2 (mod 4)
  - e(n) ≥ 2 if k(n) ≡ 0 (mod 4)
  
  By Lemma 2, the last case never occurs along the orbit from n₀ = 1.
-/
theorem e_value_from_invariant (n : Nat) (h_inv : invariant n) :
  e n = 0 ∨ e n = 1 := by
  sorry

/-
  No consecutive halving: if e(nₜ) = 1, then e(nₜ₊₁) = 0
  
  This follows because when e(nₜ) = 1, we have k(nₜ) ≡ 2 (mod 4),
  and by Lemma 1 part 2, k(nₜ₊₁) = nₜ + 2 is odd, so e(nₜ₊₁) = 0.
-/
theorem no_consecutive_halving (n : Nat) (h_odd : isOdd n) (h_inv : invariant n) 
  (h_e : e n = 1) : e (T n) = 0 := by
  sorry

section Examples

-- Example: compute the first few terms of the orbit starting at 1
-- According to Table 1 in the paper:
-- t=0: n(0) = 1
-- t=1: n(1) = 5
-- t=2: n(2) = 11
-- t=3: n(3) = 19* (halving step)
-- t=4: n(4) = 15
-- t=5: n(5) = 25

#eval orbit 1 0  -- Expected: 1
#eval orbit 1 1  -- Expected: 5
#eval orbit 1 2  -- Expected: 11
#eval orbit 1 3  -- Expected: 19 or close (depends on approximation)
#eval orbit 1 4  -- Expected: 15 or close
#eval orbit 1 5  -- Expected: 25 or close

-- Display the first 15 terms
#eval (List.range 15).map (orbit 1)

-- Helper to check if we're getting the right pattern
def checkOrbitGrowth (n0 : Nat) (len : Nat) : List (Nat × Bool) :=
  (List.range len).map fun t =>
    let curr := orbit n0 t
    let next := orbit n0 (t + 1)
    (curr, next > curr)

-- More detailed orbit information
structure OrbitStep where
  t : Nat           -- time step
  n : Nat           -- value at time t
  k_n : Nat         -- k(n) = ⌊√2·n⌋
  r_n : Nat         -- R(n) = k(n) + 4
  e_n : Nat         -- e(n) = ν₂(R(n))
  next : Nat        -- T(n)
  grew : Bool       -- did it grow from previous step?

def orbitStepInfo (n0 : Nat) (t : Nat) : OrbitStep :=
  let n := orbit n0 t
  let k_n := k n
  let r_n := R n
  let e_n := e n
  let next := T n
  let grew := if t = 0 then true else next > n
  { t := t, n := n, k_n := k_n, r_n := r_n, e_n := e_n, next := next, grew := grew }

def detailedOrbit (n0 : Nat) (len : Nat) : List OrbitStep :=
  (List.range len).map (orbitStepInfo n0)

-- Check growth pattern for n0 = 1
#eval checkOrbitGrowth 1 20

-- Example: show detailed information for first 10 steps
-- Note: The actual values might differ slightly from the paper due to 
-- the rational approximation of √2, but the structure should be similar
-- #eval detailedOrbit 1 10  -- Commented out due to missing Repr instance

end Examples

end CollatzDivergence
