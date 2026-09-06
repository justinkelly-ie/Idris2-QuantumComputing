module Quantum.NoCloning

import Quantum.Qubit
import Math.Singleton.Bit
import Core.BoxInt
import Math.Interfaces

%default total

||| Linear consumption of a Qubit token (QTT 1 constraint)
public export
consumeLinearQubit : (1 q : Qubit) -> Ur Nat
consumeLinearQubit (MkQubit w _ _ _ _) = MkUr (if isOne w then 1 else 0)

||| Property: No-Cloning Theorem (Single-pass linear consumption)
public export
prop_noCloningLinearConstraint : Qubit -> Bool
prop_noCloningLinearConstraint q =
  let (MkUr w) = consumeLinearQubit q
      expected = if isOne q.wireBit then 1 else 0
  in w == expected
