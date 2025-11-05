/-!
# First-Order Predicate Logic Formula

This example demonstrates how to express a first-order predicate logic formula in Lean.

## The Question (in German)

"Ist die folgende Formel der Prädikatenlogik 1. Stufe widersprüchlich im Sinne der 
Prädikatenlogik 1. Stufe (ich verwende "A" für den Allquantor, "E" für den Existenzquantor, 
"~" für die Negation, "&" für die Konjunktion, "->" für die Implikation): 
AxEyFxy & AxAyAz((Fxy & Fyz) -> Fxz) & Ax~Fxx ?"

## English Translation

"Is the following formula of first-order predicate logic contradictory in the sense of 
first-order predicate logic (I use "A" for the universal quantifier, "E" for the existential 
quantifier, "~" for negation, "&" for conjunction, "->" for implication): 
∀x∃yF(x,y) ∧ ∀x∀y∀z((F(x,y) ∧ F(y,z)) → F(x,z)) ∧ ∀x¬F(x,x) ?"

## Formula Analysis

The formula consists of three parts:
1. ∀x∃yF(x,y) - For every x, there exists a y such that F(x,y) holds
2. ∀x∀y∀z((F(x,y) ∧ F(y,z)) → F(x,z)) - F is transitive
3. ∀x¬F(x,x) - F is irreflexive (no element is related to itself)

This formula describes a relation F that is:
- Non-empty (every element has at least one successor)
- Transitive
- Irreflexive

This combination is indeed contradictory, as it would require an infinite descending chain,
which cannot exist in classical first-order logic.

## Lean Translation

In Lean, we can express this formula as follows:
-/

/-- The first-order logic formula from the question.
    Given a type α (the domain of discourse) and a binary relation F on α,
    this formula states that:
    1. For every x, there exists y such that F(x,y)
    2. F is transitive
    3. F is irreflexive -/
def FormulaFromQuestion (α : Type) (F : α → α → Prop) : Prop :=
  -- Part 1: For every x, there exists y such that F(x,y)
  (∀ x, ∃ y, F x y) ∧
  -- Part 2: F is transitive
  (∀ x y z, F x y → F y z → F x z) ∧
  -- Part 3: F is irreflexive
  (∀ x, ¬F x x)

/-!
## Why is this Formula Contradictory?

The formula is contradictory because it requires an infinite descending chain:
- Start with any element x₀
- By part 1, there exists x₁ such that F(x₀, x₁)
- By part 3, x₁ ≠ x₀ (since F is irreflexive)
- By part 1 again, there exists x₂ such that F(x₁, x₂)
- By transitivity, F(x₀, x₂)
- By irreflexivity, x₂ ≠ x₁ and x₂ ≠ x₀
- This process continues infinitely...

In classical first-order logic with a finite domain, such an infinite chain cannot exist.
Therefore, the formula has no model and is contradictory.

A formal proof would require additional axioms about the domain (e.g., well-foundedness
or finiteness), which we don't include here for simplicity.
-/

/-!
## Example Usage

Here's how you can use the formula definition with a specific domain:
-/

-- Example: Check if the formula holds for natural numbers with the "less than" relation
#check FormulaFromQuestion Nat (· < ·)

-- You can also instantiate it with a variable relation
variable (α : Type) (R : α → α → Prop)
#check FormulaFromQuestion α R

/-!
## Summary

The formula in Lean notation is:
```lean
(∀ x, ∃ y, F x y) ∧ (∀ x y z, F x y → F y z → F x z) ∧ (∀ x, ¬F x x)
```

Where:
- `∀` is the universal quantifier (for all)
- `∃` is the existential quantifier (there exists)
- `∧` is conjunction (and)
- `→` is implication
- `¬` is negation (not)
- `F` is the binary relation

This can be written in a Lean file and type-checked to verify its correctness.

## Quick Reference

To use this formula in your own Lean file:

```lean
-- Define the formula for any type α and relation F
def FormulaFromQuestion (α : Type) (F : α → α → Prop) : Prop :=
  (∀ x, ∃ y, F x y) ∧ (∀ x y z, F x y → F y z → F x z) ∧ (∀ x, ¬F x x)
```

Or, for a specific relation:
```lean
variable (α : Type) (F : α → α → Prop)

-- The formula states:
#check (∀ x, ∃ y, F x y) ∧ (∀ x y z, F x y → F y z → F x z) ∧ (∀ x, ¬F x x)
```
-/
