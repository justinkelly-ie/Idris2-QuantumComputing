module Quantum.Qubit

import Math.Singleton.Bit
import Math.Singleton.Sing
import Math.Dihedron.Dihedron
import Core.BoxInt
import Core.VexelMaxel
import Core.UnixelFraction

%default total

||| A Qubit State |ψ⟩ = α|0⟩ + β|1⟩ over Boolean Singletons Bit.
public export
record Qubit where
  constructor MkQubit
  wireBit : Bit
  amp0    : Core.BoxInt.BoxInt   -- Amplitude for |0⟩
  phase0  : Dihedron -- Phase vector for |0⟩
  amp1    : Core.BoxInt.BoxInt   -- Amplitude for |1⟩
  phase1  : Dihedron -- Phase vector for |1⟩

public export
Eq Qubit where
  (MkQubit w1 a0 ph0 a1 ph1) == (MkQubit w2 b0 qh0 b1 qh1) =
    (isOne w1 == isOne w2) && a0 == b0 && ph0 == qh0 && a1 == b1 && ph1 == qh1

public export
Show Qubit where
  show (MkQubit w a0 p0 a1 p1) =
    let wStr = if isOne w then "1" else "0"
    in "[Qubit wire=" ++ wStr ++ " | |0>: amp=" ++ show a0 ++ " phase=(" ++ show p0 ++ ")" ++
       " | |1>: amp=" ++ show a1 ++ " phase=(" ++ show p1 ++ ")]"

-----------------------------------------------------------------------
-- QUBIT CONSTRUCTORS
-----------------------------------------------------------------------

||| Pure Basis State |0⟩
public export
qubitZero : Bit -> Qubit
qubitZero b = MkQubit b 1 (MkDihedron 1 0 0 0) 0 (MkDihedron 0 0 0 0)

||| Pure Basis State |1⟩
public export
qubitOne : Bit -> Qubit
qubitOne b = MkQubit b 0 (MkDihedron 0 0 0 0) 1 (MkDihedron 1 0 0 0)

-----------------------------------------------------------------------
-- QUANTUM GATES
-----------------------------------------------------------------------

||| Pauli-X Gate (Quantum NOT Gate): Swaps |0⟩ ↔ |1⟩ via negBit
public export
gateX : Qubit -> Qubit
gateX (MkQubit w a0 p0 a1 p1) = MkQubit (negBit w) a1 p1 a0 p0

||| Pauli-Z Gate (Phase Flip Gate): Flips the phase of |1⟩ by π (negDihedron)
public export
gateZ : Qubit -> Qubit
gateZ (MkQubit w a0 p0 a1 p1) = MkQubit w a0 p0 a1 (negDihedron p1)

||| Hadamard Gate (H): Puts pure basis state into equal superposition
public export
gateH : Qubit -> Qubit
gateH (MkQubit w a0 p0 a1 p1) =
  let inPhase = MkDihedron 1 0 0 0
  in MkQubit w 1 inPhase 1 inPhase

-----------------------------------------------------------------------
-- MEASUREMENT PROBABILITIES
-----------------------------------------------------------------------

||| Exact Rational Probability P(|0⟩) = |amp0|² / (|amp0|² + |amp1|²)
public export
probZero : Qubit -> UnixelFraction
probZero (MkQubit _ a0 _ a1 _) =
  let i0 = a0 * a0
      i1 = a1 * a1
      iTotal = i0 + i1
      denNat = if iTotal.value > 0 then Prelude.integerToNat iTotal.value else 1
  in mkUnixelFraction i0 denNat

||| Exact Rational Probability P(|1⟩) = |amp1|² / (|amp0|² + |amp1|²)
public export
probOne : Qubit -> UnixelFraction
probOne (MkQubit _ a0 _ a1 _) =
  let i0 = a0 * a0
      i1 = a1 * a1
      iTotal = i0 + i1
      denNat = if iTotal.value > 0 then Prelude.integerToNat iTotal.value else 1
  in mkUnixelFraction i1 denNat

-----------------------------------------------------------------------
-- VERIFIED QUBIT PROPERTIES
-----------------------------------------------------------------------

||| Property 1: Pauli-X Involution Law (X(X |ψ⟩) == |ψ⟩)
public export
prop_pauliXInvolution : Qubit -> Bool
prop_pauliXInvolution q = gateX (gateX q) == q

||| Property 2: Qubit Probability Normalization Law (P(|0⟩) + P(|1⟩) == 1.0)
public export
prop_probabilityNormalized : Qubit -> Bool
prop_probabilityNormalized q =
  let p0 = probZero q
      p1 = probOne q
      tot = addUnixelFraction p0 p1
  in tot.num == natToBoxInt (unwrapUnixel tot.den)
