/-
  Formulation of a mathematical inequality problem involving a cyclic sequence.
  
  Given:
  - A natural number N (N > 0)
  - A sequence u[i] for i from 1 to N, where all u[i] ≠ 0
  - Boundary conditions: u[0] = u[N] and u[N+1] = u[1]
  
  Claim:
  Sum[u[i]*(u[i-1]^2 - 4*u[i]^2 + 3*u[i+1]^2), {i, 1, N}] ≤ 0
  
  This file demonstrates how to formulate this problem in Lean 4.
-/

/-- Access the sequence with cyclic boundary conditions.
    For a sequence u indexed from 1 to N:
    - u[0] = u[N]
    - u[N+1] = u[1]
    We use modular arithmetic for cyclic indexing. -/
def cyclicIndex (N : Nat) (i : Int) : Nat :=
  if N = 0 then 0
  else 
    let normalized := i % (N : Int)
    if normalized ≤ 0 then (normalized + N).toNat
    else normalized.toNat

/-- Access element at cyclic index -/
def cyclicAt (N : Nat) (u : Nat → ℚ) (i : Int) : ℚ :=
  u (cyclicIndex N i)

/-- The term in the sum: u[i]*(u[i-1]^2 - 4*u[i]^2 + 3*u[i+1]^2) -/
def sumTerm (N : Nat) (u : Nat → ℚ) (i : Nat) : ℚ :=
  let ui := cyclicAt N u i
  let ui_minus_1 := cyclicAt N u (i - 1)
  let ui_plus_1 := cyclicAt N u (i + 1)
  ui * (ui_minus_1^2 - 4*ui^2 + 3*ui_plus_1^2)

/-- The sum from i=1 to N -/
def cyclicSum (N : Nat) (u : Nat → ℚ) : ℚ :=
  (List.range N).foldl (fun acc i => acc + sumTerm N u (i + 1)) 0

/-- Main theorem: The cyclic sum is non-positive.
    
    Given a natural number N > 0 and a sequence u : Nat → ℚ where all u[i] ≠ 0
    for i from 1 to N, with boundary conditions u[0] = u[N] and u[N+1] = u[1],
    we claim that: Sum[u[i]*(u[i-1]^2 - 4*u[i]^2 + 3*u[i+1]^2), {i, 1, N}] ≤ 0
    
    The proof is left as 'sorry' - this formulation shows how to state the problem in Lean. -/
theorem cyclic_sum_inequality (N : Nat) (hN : N > 0) (u : Nat → ℚ) 
    (nonzero : ∀ i : Nat, 1 ≤ i → i ≤ N → u i ≠ 0)
    (boundary_0 : cyclicAt N u 0 = cyclicAt N u N)
    (boundary_N_plus_1 : cyclicAt N u (N + 1) = cyclicAt N u 1) :
    cyclicSum N u ≤ 0 := by
  sorry  -- The proof would go here

/-- Alternative formulation using a finite function indexed by Fin N.
    This version uses cyclic indexing via modular arithmetic. -/
def cyclicSumFin (N : Nat) (u : Fin N → ℚ) : ℚ :=
  let indices := List.range N
  indices.foldl (fun acc idx =>
    if h : idx < N then
      let i : Fin N := ⟨idx, h⟩
      let ui := u i
      let prev_idx := (idx + N - 1) % N
      let next_idx := (idx + 1) % N
      have hprev : prev_idx < N := Nat.mod_lt _ (Nat.zero_lt_of_lt h)
      have hnext : next_idx < N := Nat.mod_lt _ (Nat.zero_lt_of_lt h)
      let ui_prev := u ⟨prev_idx, hprev⟩
      let ui_next := u ⟨next_idx, hnext⟩
      acc + ui * (ui_prev^2 - 4*ui^2 + 3*ui_next^2)
    else
      acc
  ) 0

/-- Theorem using Fin-indexed formulation.
    
    This states that for any cyclic sequence of non-zero rationals indexed by Fin N,
    the sum of u[i]*(u[i-1]^2 - 4*u[i]^2 + 3*u[i+1]^2) over all i is non-positive.
    
    Note: The cyclic boundary conditions are implicit in the Fin N indexing with
    modular arithmetic. -/
theorem cyclic_sum_inequality_fin (N : Nat) (hN : N > 0) (u : Fin N → ℚ) 
    (nonzero : ∀ i : Fin N, u i ≠ 0) :
    cyclicSumFin N u ≤ 0 := by
  sorry

-- Verify that the definitions are well-formed
#check cyclicSum
#check sumTerm
#check cyclicAt
#check cyclicIndex
#check cyclic_sum_inequality
#check cyclicSumFin
#check cyclic_sum_inequality_fin

/-- Example with concrete values to illustrate usage.
    This shows that there exists a non-zero cyclic sequence of length 3
    satisfying the inequality. -/
example : ∃ (u : Fin 3 → ℚ), 
    (∀ i : Fin 3, u i ≠ 0) ∧ 
    cyclicSumFin 3 u ≤ 0 := by
  sorry
