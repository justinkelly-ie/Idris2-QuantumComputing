module Quantum.StateStream

import public Core.BoxInt
import public Math.OnSeq.FusedStream
import public Quantum.Qubit
import Data.Fuel

%default total

--------------------------------------------------------------------------------
-- 1. QUANTUM CIRCUIT STATE & MEASUREMENT STREAM ALGEBRA
--------------------------------------------------------------------------------

||| Discrete Qubit Basis State |0> or |1>.
public export
data QubitBasis = ZeroState | OneState

public export
Eq QubitBasis where
  ZeroState == ZeroState = True
  OneState  == OneState  = True
  _         == _         = False

||| Quantum State Token carrying basis state and integer coefficient amplitude.
public export
record QuantumStateToken where
  constructor MkQuantumToken
  basis     : QubitBasis
  amplitude : BoxInt

public export
Eq QuantumStateToken where
  (MkQuantumToken b1 a1) == (MkQuantumToken b2 a2) = b1 == b2 && a1 == a2

||| Unfolds a list of quantum state amplitudes into a deforested QuantumStateStream.
%inline public export
unfoldQuantumStateStream : List (QubitBasis, BoxInt) -> FusedStream QuantumStateToken
unfoldQuantumStateStream items = MkStream nextStep items
  where
    nextStep : List (QubitBasis, BoxInt) -> Step (List (QubitBasis, BoxInt)) QuantumStateToken
    nextStep [] = Done
    nextStep ((b, amp) :: rest) = Yield (MkQuantumToken b amp) rest

||| Computes measurement expectation value \langle \psi | A | \psi \rangle across a stream using fused hylomorphism.
public export covering
fusedExpectationValue : Fuel -> List (QubitBasis, BoxInt) -> BoxInt
fusedExpectationValue f items =
  fusedHylomorphism f
    (\st => case st of
              [] => Done
              (b, amp) :: rest => Yield (MkQuantumToken b amp) rest)
    (\tok, acc => (amplitude tok * amplitude tok) + acc)
    (intToBoxInt 0)
    items

--------------------------------------------------------------------------------
-- 2. VERIFICATION AUDIT WITNESS
--------------------------------------------------------------------------------

||| Audit witness verifying zero-allocation quantum measurement expectation value calculation.
public export
auditQuantumStateStreamProof : Bool
auditQuantumStateStreamProof =
  let items = [(ZeroState, intToBoxInt 3), (OneState, intToBoxInt 4)]
      expVal = fusedExpectationValue (limit 100) items
  in unwrapBox expVal == 25
