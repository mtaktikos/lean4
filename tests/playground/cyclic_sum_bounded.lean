/-
  Cyclic Sum Inequality with Bounded Reals
  
  Problem Statement:
  Let N be a natural number and let 0 ≤ u_i ≤ 1 (for reals u_i) for indices i between 1 and N.
  We set u_0 = u_N and u_{-1} = u_{N-1}.
  
  The claim is:
  ∑_{i=1}^N u_i (u_{i-2}^2 - 4 u_{i-1}^2 + 3 u_i^2) ≥ 0
  
  This file provides a formal translation of this problem into Lean 4.
  
  NOTE: Real numbers (ℝ) require Mathlib. This file assumes Mathlib is available.
  If you don't have Mathlib, see the rational number versions below that work
  with standard Lean 4.
-/

/-- The cyclic sum formula for the bounded case.
    Sum of u[i]*(u[i-2]^2 - 4*u[i-1]^2 + 3*u[i]^2) for i from 1 to N
    
    We use Fin N to represent indices 0, 1, ..., N-1.
    The cyclic boundary conditions are handled via modular arithmetic:
    - u[0] corresponds to u_1 in the problem statement
    - u[i-1] for i=0 wraps to u[N-1] (i.e., u_N in 1-indexed notation)
    - u[i-2] for i=0 wraps to u[N-2] (i.e., u_{N-1} in 1-indexed notation)
    - u[i-2] for i=1 wraps to u[N-1] (i.e., u_N in 1-indexed notation)
-/
def cyclicSumBounded (N : Nat) (u : Fin N → ℝ) : ℝ :=
  (List.range N).foldl (fun acc i =>
    if h : i < N then
      let curr := u ⟨i, h⟩
      -- For i-1: wrap around using (i + N - 1) % N
      let prev1 := u ⟨(i + N - 1) % N, Nat.mod_lt _ (Nat.zero_lt_of_lt h)⟩
      -- For i-2: wrap around using (i + N - 2) % N  
      let prev2 := u ⟨(i + N - 2) % N, Nat.mod_lt _ (Nat.zero_lt_of_lt h)⟩
      acc + curr * (prev2^2 - 4*prev1^2 + 3*curr^2)
    else acc
  ) 0

/-- The main theorem: For real-valued sequences where each element is bounded in [0,1],
    the cyclic sum is non-negative.
    
    Parameters:
    - N : Nat - the length of the sequence (must be positive)
    - u : Fin N → ℝ - the sequence of real numbers
    - bounded : ∀ i : Fin N, 0 ≤ u i ∧ u i ≤ 1 - each element is in [0,1]
    
    Conclusion:
    - cyclicSumBounded N u ≥ 0
    
    Note: The cyclic boundary conditions u_0 = u_N and u_{-1} = u_{N-1} from the 
    problem statement are automatically satisfied by the Fin N indexing with modular 
    arithmetic. Specifically:
    - When accessing u[0-1] we get u[N-1], which corresponds to u_N in 1-indexed notation
    - When accessing u[0-2] we get u[N-2], which corresponds to u_{N-1} in 1-indexed notation
-/
theorem cyclic_sum_bounded_inequality (N : Nat) (hN : N > 0) (u : Fin N → ℝ)
    (bounded : ∀ i : Fin N, 0 ≤ u i ∧ u i ≤ 1) :
    0 ≤ cyclicSumBounded N u := by
  sorry  -- Proof or counterexample needed

/-
  ALTERNATIVE FORMULATION: Using explicit boundary conditions
  
  This version makes the boundary conditions more explicit for clarity.
-/

/-- Alternative formulation using natural number indexing with explicit boundaries -/
def cyclicSumBoundedNat (N : Nat) (u : Nat → ℝ) : ℝ :=
  -- Sum from i=1 to N
  (List.range N).foldl (fun acc idx => 
    let i := idx + 1  -- Convert 0-based to 1-based indexing
    acc + u i * (u (i - 2) ^ 2 - 4 * u (i - 1) ^ 2 + 3 * u i ^ 2)
  ) 0

/-- Helper to define cyclic indexing for natural numbers -/
def cyclicAccess (N : Nat) (u : Nat → ℝ) (i : Int) : ℝ :=
  if N = 0 then 0
  else
    -- Normalize i to be in range [1, N]
    let normalized := ((i - 1) % (N : Int) + N) % N + 1
    u normalized.toNat

/-- The theorem using natural number indexing with explicit boundary conditions -/
theorem cyclic_sum_bounded_inequality_nat (N : Nat) (hN : N > 0) (u : Nat → ℝ)
    (bounded : ∀ i : Nat, 1 ≤ i → i ≤ N → 0 ≤ u i ∧ u i ≤ 1)
    (boundary_0 : u 0 = u N)
    (boundary_minus_1 : u (N - 1) = cyclicAccess N u (-1)) :
    0 ≤ cyclicSumBoundedNat N u := by
  sorry  -- Proof or counterexample needed

/-
  EXAMPLES AND VERIFICATION
  
  Below are examples to demonstrate how to use the formulations.
-/

/-- Example: A constant sequence of all 0.5's -/
def constantHalf (N : Nat) : Fin N → ℝ := fun _ => 1/2

example : ∀ (N : Nat), N > 0 → 0 ≤ cyclicSumBounded N (constantHalf N) := by
  intro N hN
  apply cyclic_sum_bounded_inequality
  · exact hN
  · intro i
    constructor
    · norm_num [constantHalf]
    · norm_num [constantHalf]

/-- Example: A sequence that varies between 0 and 1 -/
def alternatingSeq : Fin 4 → ℝ
  | ⟨0, _⟩ => 0
  | ⟨1, _⟩ => 1
  | ⟨2, _⟩ => 0
  | ⟨3, _⟩ => 1
  | ⟨n+4, h⟩ => absurd h (Nat.not_lt_of_le (Nat.le_refl _))

-- Verify bounded property
example : ∀ i : Fin 4, 0 ≤ alternatingSeq i ∧ alternatingSeq i ≤ 1 := by
  intro i
  match i with
  | ⟨0, _⟩ | ⟨1, _⟩ | ⟨2, _⟩ | ⟨3, _⟩ => 
    constructor <;> norm_num [alternatingSeq]
  | ⟨n+4, h⟩ => exact absurd h (Nat.not_lt_of_le (Nat.le_refl _))

-- The main inequality should hold (once proved)
example : 0 ≤ cyclicSumBounded 4 alternatingSeq := by
  apply cyclic_sum_bounded_inequality
  · decide
  · intro i
    match i with
    | ⟨0, _⟩ | ⟨1, _⟩ | ⟨2, _⟩ | ⟨3, _⟩ => 
      constructor <;> norm_num [alternatingSeq]
    | ⟨n+4, h⟩ => exact absurd h (Nat.not_lt_of_le (Nat.le_refl _))

/-
  NOTES ON THE FORMULATION:
  
  1. Index Mapping:
     - The problem uses 1-based indexing (i from 1 to N)
     - Lean's Fin N uses 0-based indexing (i from 0 to N-1)
     - Element at Lean index i corresponds to u_{i+1} in the problem notation
  
  2. Boundary Conditions:
     - u_0 = u_N means: the element before index 1 equals the element at index N
     - u_{-1} = u_{N-1} means: the element two positions before index 1 equals u_{N-1}
     - With Fin N and modular arithmetic, these are automatic:
       * Accessing index -1 from Fin N wraps to N-1
       * Accessing index -2 from Fin N wraps to N-2
  
  3. The Sum Expression:
     - For each i from 1 to N (or 0 to N-1 in Fin indexing)
     - We compute: u_i * (u_{i-2}^2 - 4*u_{i-1}^2 + 3*u_i^2)
     - The modular arithmetic ensures proper cyclic wrapping
  
  4. Type Choice:
     - Using ℝ (real numbers) as specified in the problem
     - The bounded constraint ensures 0 ≤ u_i ≤ 1
  
  5. Proof Status:
     - Both formulations use 'sorry' as placeholder
     - A proof or counterexample is needed to complete this
-/

/-
  RATIONAL NUMBER VERSIONS
  
  For use with standard Lean 4 (without Mathlib), we provide versions using
  rational numbers (ℚ) which are available in the standard library.
  
  These versions are mathematically equivalent for the inequality since rationals
  are dense in the reals and the inequality is polynomial.
-/

/-- The cyclic sum formula using rational numbers.
    This works with standard Lean 4 without requiring Mathlib. -/
def cyclicSumBoundedRat (N : Nat) (u : Fin N → ℚ) : ℚ :=
  (List.range N).foldl (fun acc i =>
    if h : i < N then
      let curr := u ⟨i, h⟩
      -- For i-1: wrap around using (i + N - 1) % N
      let prev1 := u ⟨(i + N - 1) % N, Nat.mod_lt _ (Nat.zero_lt_of_lt h)⟩
      -- For i-2: wrap around using (i + N - 2) % N  
      let prev2 := u ⟨(i + N - 2) % N, Nat.mod_lt _ (Nat.zero_lt_of_lt h)⟩
      acc + curr * (prev2^2 - 4*prev1^2 + 3*curr^2)
    else acc
  ) 0

/-- The main theorem using rational numbers.
    For rational-valued sequences where each element is bounded in [0,1],
    the cyclic sum is non-negative. -/
theorem cyclic_sum_bounded_inequality_rat (N : Nat) (hN : N > 0) (u : Fin N → ℚ)
    (bounded : ∀ i : Fin N, 0 ≤ u i ∧ u i ≤ 1) :
    0 ≤ cyclicSumBoundedRat N u := by
  sorry  -- Proof or counterexample needed

/-- Example with rationals: A constant sequence of all 1/2's -/
def constantHalfRat (N : Nat) : Fin N → ℚ := fun _ => 1/2

-- Verify bounded property
example : ∀ (N : Nat) (i : Fin N), 0 ≤ constantHalfRat N i ∧ constantHalfRat N i ≤ 1 := by
  intro N i
  constructor <;> norm_num [constantHalfRat]

-- Apply the theorem
example : ∀ (N : Nat), N > 0 → 0 ≤ cyclicSumBoundedRat N (constantHalfRat N) := by
  intro N hN
  apply cyclic_sum_bounded_inequality_rat
  · exact hN
  · intro i
    constructor <;> norm_num [constantHalfRat]

/-- Example with rationals: Alternating 0 and 1 -/
def alternatingSeqRat : Fin 4 → ℚ
  | ⟨0, _⟩ => 0
  | ⟨1, _⟩ => 1
  | ⟨2, _⟩ => 0
  | ⟨3, _⟩ => 1
  | ⟨n+4, h⟩ => absurd h (Nat.not_lt_of_le (Nat.le_refl _))

-- Compute the sum for this specific sequence
#eval cyclicSumBoundedRat 4 alternatingSeqRat

-- Type check all definitions
#check cyclicSumBounded
#check cyclic_sum_bounded_inequality
#check cyclicSumBoundedNat
#check cyclic_sum_bounded_inequality_nat
#check constantHalf
#check alternatingSeq
#check cyclicSumBoundedRat
#check cyclic_sum_bounded_inequality_rat
#check constantHalfRat
#check alternatingSeqRat
