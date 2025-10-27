(* CyclicInequalities.m
   Simple Mathematica package with helpers for cyclic sums, cyclic products,
   and a numeric checker for cyclic inequalities.

   Version: 0.1
   Author: mtaktikos (adapted)
   Plain-text Mathematica package file
*)

BeginPackage["CyclicInequalities`"]

CyclicSum::usage = "CyclicSum[expr, {a,b,c,...}] returns the cyclic sum of expr over the variables in the list.";
CyclicProduct::usage = "CyclicProduct[expr, {a,b,c,...}] returns the cyclic product (sum of products) of expr over the variables in the list.";
CheckCyclicInequality::usage = "CheckCyclicInequality[ineq, {a,b,c,...}, OptionsPattern[]] performs numeric tests of the relational inequality ineq for random assignments. Options: NumTests (default 100), Domain (PositiveReals or All), Tol (unused placeholder). Returns an Association with result and counterexample if found.";

Options[CheckCyclicInequality] = {NumTests -> 100, Domain -> PositiveReals, Tol -> 0.};

Begin["`Private`"]

(* Helper: produce a substitution mapping vars -> rotated version by k positions *)
rotateSubstitution[vars_List, k_Integer] := Thread[vars -> RotateLeft[vars, k]]

(* CyclicSum: sum expr over cyclic rotations of the variables list *)
CyclicSum[expr_, vars_List] /; Length[vars] >= 1 := Module[{n = Length[vars]},
  Sum[expr /. rotateSubstitution[vars, k], {k, 0, n - 1}]
]

(* CyclicProduct: sum of products produced by substituting rotated variables into expr *)
CyclicProduct[expr_, vars_List] /; Length[vars] >= 1 := Module[{n = Length[vars]},
  Sum[Times @@ (expr /. rotateSubstitution[vars, k] /; ListQ[expr]) , {k, 0, n - 1}] /; False
]

(* Alternate simpler product aggregator: apply expr (which may be a product expression) under rotation and sum *)
CyclicProduct[expr_, vars_List] /; Length[vars] >= 1 := Module[{n = Length[vars]},
  Sum[Evaluate[expr] /. rotateSubstitution[vars, k], {k, 0, n - 1}]
]

(* CheckCyclicInequality:
   ineq is a Mathematica relational (e.g. a^2 + b^2 >= 2 a b)
   vars is a list of symbols {a,b,c,...}
   Options: NumTests -> integer, Domain -> PositiveReals|All
   Returns <|"Holds"->True|> or <|"Holds"->False, "CounterExample"->{vals}|>
*)
CheckCyclicInequality[ineq_, vars_List, opts : OptionsPattern[]] := Module[
  {num = OptionValue[NumTests], dom = OptionValue[Domain], tol = OptionValue[Tol], f, i, sample},
  (* Build a numeric-function version of the relational *)
  f = Function @@ {vars, ineq}; (* e.g. Function[{a,b,c}, a^2 + b^2 >= c^2] *)

  Do[
    sample = Switch[dom,
      PositiveReals, RandomReal[{10^-6, 5}, Length[vars]],
      All, RandomReal[{-5, 5}, Length[vars]],
      _, RandomReal[{-5, 5}, Length[vars]]
    ];
    (* Evaluate the relational on the sample; TrueQ ensures symbolic leftovers return False *)
    If[! TrueQ[f @@ sample],
      Return[<|"Holds" -> False, "CounterExample" -> sample|>]
    ],
    {i, num}
  ];
  <|"Holds" -> True|>
]

End[] (* `Private` *)

EndPackage[]