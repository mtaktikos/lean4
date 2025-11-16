# Index: Lean 4 Formalization of Collatz-Type Divergence Theorem

## Quick Start

**New to this project?** Start here:
1. 📄 Read [`README.md`](README.md) - Main documentation and overview
2. 💻 Explore [`DivergenceTheorem.lean`](DivergenceTheorem.lean) - The formalization
3. 📊 Check [`COMPARISON.md`](COMPARISON.md) - Compare with paper results

**Want to complete the proofs?** See:
- 🎯 [`PROOF_GUIDE.md`](PROOF_GUIDE.md) - Step-by-step proof strategy

**Want the big picture?** Read:
- 📋 [`SUMMARY.md`](SUMMARY.md) - Project overview and accomplishments

## File Guide

### Primary Files

#### `DivergenceTheorem.lean` (294 lines, 8.3 KB)
**The main formalization file**

Contains:
- 7 core definitions: `nu2`, `floorSqrt2Times`, `T`, `k`, `R`, `e`, `orbit`
- 8 predicate definitions: `isOdd`, `isEven`, `invariant`, `kIsOdd`, `kMod2_4`, `kMod0_4`
- 18 theorem statements including:
  - Lemma 1 (transition properties) - 4 theorems
  - Lemma 2 (invariant persistence) - 3 theorems
  - Lemma 3 (multi-halving bound) - 1 theorem
  - Main Theorem (divergence) - 3 theorems
  - Supporting lemmas - 7 theorems
- Computational examples and visualization helpers

**Use for**: Understanding the formalization, computational verification

#### `divergence-paper--sept-08-2025.pdf` (361 KB)
**Original research paper by Ingo Althöfer and Thomas Zipproth**

The source material for this formalization.

**Use for**: Mathematical background, understanding the proofs

### Documentation Files

#### `README.md` (141 lines, 5.3 KB)
**Main documentation and user guide**

Sections:
- Paper summary and context
- File structure explanation
- Mathematical background (√2 approximation)
- Key insight (two-step drift)
- How to use
- Current status and future work
- References

**Use for**: First-time users, understanding the mathematics

#### `COMPARISON.md` (102 lines, 3.9 KB)
**Comparison with paper results**

Contains:
- Table 1 from paper (n₀ = 1, t = 0 to 30)
- √2 approximation discussion
- Expected behavior
- Verification instructions
- Why differences may occur
- Theoretical robustness

**Use for**: Validating computational results, understanding approximations

#### `SUMMARY.md` (201 lines, 6.7 KB)
**Project overview and accomplishments**

Sections:
- What was accomplished
- Core formalization details
- Documentation overview
- Key features
- Technical highlights
- What this enables
- Next steps
- File manifest

**Use for**: High-level understanding, sharing/citing the project

#### `PROOF_GUIDE.md` (279 lines, 8.8 KB)
**Complete strategy for finishing proofs**

Sections:
- Proof strategy overview (dependency chain)
- Level 1: Basic properties (easiest)
- Level 2: Lemma 1 (moderate)
- Level 3: Lemma 2 (moderate to hard)
- Level 4: Lemma 3 (moderate)
- Level 5: Main Theorem (hard)
- Recommended proving order
- Useful Lean tactics
- Additional lemmas needed
- Notes on √2 approximation

**Use for**: Completing the formal proofs, learning Lean proving

#### `INDEX.md` (this file)
**Navigation guide for the project**

**Use for**: Finding your way around the formalization

### Utility Files

#### `run_examples.sh` (77 lines, 2.4 KB)
**Executable script for running examples**

Features:
- Checks for Lean installation
- Runs computational examples
- Displays orbit values
- Shows detailed step information
- Compares with paper Table 1
- Verifies growth patterns

**Use for**: Automated testing and verification

## Component Organization

### Definitions (in `DivergenceTheorem.lean`)

```
Basic Operations:
├── nu2           - Count factors of 2
├── floorSqrt2Times - Compute ⌊√2·n⌋
└── T             - Main recursion function

Helper Functions (Paper Notation):
├── k             - ⌊√2·n⌋
├── R             - k(n) + 4
├── e             - ν₂(R(n))
└── orbit         - Sequence generator

Predicates:
├── isOdd, isEven - Parity
├── invariant     - I(n): k(n) ≢ 0 (mod 4)
└── kIsOdd, kMod2_4, kMod0_4 - Properties of k(n) mod 4
```

### Theorems (in `DivergenceTheorem.lean`)

```
Basic Properties:
├── nu2_zero, nu2_odd, nu2_even
├── T_eq_T'
└── odd_not_even

Connection Lemmas:
├── e_cases
├── e_from_k_odd, e_from_k_mod2, e_from_k_mod0
└── e_value_from_invariant

Lemma 1 (Transition):
├── lemma1_part1        - Odd k case
├── lemma1_part2        - k ≡ 2 (mod 4) case
├── lemma1_part1_range  - Range of k(T(n))
└── lemma1_part2_exact  - Exact k(T(n)) = n + 2

Lemma 2 (Invariant):
├── lemma2_base         - Base case: I(1)
├── lemma2_inductive    - Inductive step
└── lemma2              - Full statement

Lemma 3 (Multi-halving):
└── lemma3              - Bound on multi-halving

Main Results:
├── main_theorem_growth      - Growth property
├── main_theorem_unbounded   - Unboundedness
├── no_finite_cycles         - Corollary
└── no_consecutive_halving   - Halving property
```

### Examples (in `DivergenceTheorem.lean`)

```
Basic Examples:
├── orbit 1 t for t = 0..5
└── First 15 terms of orbit

Visualization:
├── checkOrbitGrowth    - Shows (value, grew?) pairs
├── orbitStepInfo       - Detailed step information
└── detailedOrbit       - Full orbit with all details
```

## Project Statistics

| Metric | Value |
|--------|-------|
| Total files | 7 (1 PDF, 1 Lean, 5 docs) |
| Lean code | 294 lines |
| Documentation | 723 lines |
| Scripts | 77 lines |
| Total (excl. PDF) | 1,094 lines |
| Total size | ~32 KB (excl. PDF) |
| Definitions | 15 |
| Theorems | 18 |
| Examples | 5 |

## Reading Order

### For Mathematicians
1. `divergence-paper--sept-08-2025.pdf` - The mathematics
2. `README.md` - Overview of formalization
3. `DivergenceTheorem.lean` - The formalization
4. `PROOF_GUIDE.md` - Proof strategy

### For Lean Programmers
1. `README.md` - Context
2. `DivergenceTheorem.lean` - The code
3. `PROOF_GUIDE.md` - How to complete it
4. `COMPARISON.md` - Testing and validation

### For Students/Learners
1. `README.md` - Introduction
2. `SUMMARY.md` - Big picture
3. `DivergenceTheorem.lean` (examples section) - Computation
4. `COMPARISON.md` - Verification
5. `PROOF_GUIDE.md` - Learning to prove

### For Project Overview
1. `SUMMARY.md` - What was accomplished
2. `README.md` - How to use
3. `INDEX.md` (this file) - Navigation

## Key Concepts

| Concept | Definition | Where |
|---------|-----------|-------|
| **T(n)** | The main recursion: ⌊√2·n + 4⌋ / 2^ν₂ | `DivergenceTheorem.lean` line 34 |
| **ν₂(n)** | Number of times 2 divides n | `DivergenceTheorem.lean` line 17 |
| **k(n)** | ⌊√2·n⌋ | `DivergenceTheorem.lean` line 40 |
| **Invariant I(n)** | k(n) ≢ 0 (mod 4) | `DivergenceTheorem.lean` line 88 |
| **Two-step drift** | Either nₜ₊₁ > nₜ or nₜ₊₂ > nₜ | `README.md`, Main Theorem |
| **√2 approximation** | 1393/985 ≈ 1.41421319... | `DivergenceTheorem.lean` line 33 |

## Links and References

- **Paper**: `divergence-paper--sept-08-2025.pdf`
- **Lean 4 Homepage**: https://lean-lang.org
- **Theorem Proving in Lean 4**: https://lean-lang.org/theorem_proving_in_lean4/
- **Lean Zulip Chat**: https://leanprover.zulipchat.com/
- **Original Collatz**: Lagarias, "The 3x + 1 problem" (1985)

## Contributing

To complete the formalization:

1. Follow the proof strategy in `PROOF_GUIDE.md`
2. Start with Level 1 (basic properties)
3. Work through Levels 2-5 progressively
4. Test proofs with computational examples
5. Document any new lemmas needed

## License

This formalization follows the Lean 4 repository license (Apache 2.0).

## Citation

```
Lean 4 Formalization of "Divergence in a Collatz-Type Recursion"
Based on: Ingo Althöfer and Thomas Zipproth (September 8, 2025)
Repository: mtaktikos/lean4
Directory: tests/playground/ingo251116/
```

---

**Last Updated**: November 16, 2025
**Version**: 1.0 (Complete structure, proofs pending)
