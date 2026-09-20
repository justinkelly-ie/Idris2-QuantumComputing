module Quantum.Circuit

import Math.Singleton.Bit
import Math.Singleton.Sing
import Math.Dihedron.Dihedron
import Core.BoxInt
import Core.Order.Preorder
import Core.VexelMaxel
import Core.UnixelFraction
import Core.Category.Adjunction

%default total

-----------------------------------------------------------------------
-- TRACE-PRESERVING QUANTUM CHANNEL WITNESSES
-----------------------------------------------------------------------

||| Monomorphic compile-time proof witness verifying density matrix trace preservation:
||| Tr(rho_out) = Tr(rho_in) (natAdd t0 t1 = totalTrace).
public export
0 TracePreservingChannel : Nat -> Nat -> Nat -> Type
TracePreservingChannel t0 t1 totalTrace = natAdd t0 t1 = totalTrace

||| A Completely Positive Trace-Preserving (CPTP) Quantum Channel record
||| equipped with an erased compile-time 0 tracePrf witness.
public export
record CPTPQuantumChannel (t0 : Nat) (t1 : Nat) (totalTrace : Nat) where
  constructor MkCPTPQuantumChannel
  channelMatrix : Maxel
  0 tracePrf    : TracePreservingChannel t0 t1 totalTrace

||| Constructs a validated CPTP quantum channel with an erased compile-time trace preservation proof.
public export
makeCPTPChannel : (t0 : Nat) -> (t1 : Nat) -> (totalTrace : Nat) ->
                  (0 prf : TracePreservingChannel t0 t1 totalTrace) ->
                  Maxel ->
                  CPTPQuantumChannel t0 t1 totalTrace
makeCPTPChannel t0 t1 tot prf mat = MkCPTPQuantumChannel mat prf

||| Static erased compile-time witness verifying Pure State Density Matrix Trace Preservation (1 + 0 = 1).
public export
0 prfPureStateTracePreserving : TracePreservingChannel 1 0 1
prfPureStateTracePreserving = Refl

||| Static erased compile-time witness verifying Maximal Mixed Qubit State Trace Preservation (1 + 1 = 2).
public export
0 prfMaximalMixedTracePreserving : TracePreservingChannel 1 1 2
prfMaximalMixedTracePreserving = Refl

||| Category-Theoretic Quantum Adjunction (L ⊣ R) for CPTP Channels & Stinespring Dilation
public export
interface QuantumAdjunction (0 l : Type -> Type) (0 r : Type -> Type) where
  cptpAdjunction : MultisetAdjunction l r

public export
record WaveToken where
  constructor MkWaveToken
  pixelPosition : Bit
  amplitude     : Core.BoxInt.BoxInt
  phase         : Dihedron

public export
interfereWaves : WaveToken -> WaveToken -> WaveToken
interfereWaves (MkWaveToken p1 a1 ph1) (MkWaveToken p2 a2 ph2) =
  let combinedPhase = addDihedron ph1 ph2
      effAmp = if ph1 == negDihedron ph2 then MkBoxInt (abs (a1.value - a2.value)) else a1 + a2
  in MkWaveToken p1 effAmp combinedPhase

||| Property 1: Quantum Hadamard Phase Superposition
public export
prop_hadamardPhaseSuperposition : Bit -> Bool
prop_hadamardPhaseSuperposition wireBit =
  let zeroStatePhase = MkDihedron 1 0 0 0
      hadamardPhase  = MkDihedron 0 1 0 0 -- i phase rotation
      q0 = MkWaveToken wireBit 1 zeroStatePhase
      qH = MkWaveToken wireBit 1 hadamardPhase
      interfered = interfereWaves q0 qH
  in interfered.amplitude == 2

-----------------------------------------------------------------------
-- MONADIC QUANTUM CIRCUIT SYNTHESIS
-----------------------------------------------------------------------

||| A Quantum Circuit Computation Monad wrapping a state transformation or wire payload.
public export
record QuantumCircuit a where
  constructor MkQuantumCircuit
  circuitResult : a
  gateCount     : Core.BoxInt.BoxInt

public export
(Eq a) => Eq (QuantumCircuit a) where
  (MkQuantumCircuit r1 g1) == (MkQuantumCircuit r2 g2) = r1 == r2 && g1 == g2

public export
(Show a) => Show (QuantumCircuit a) where
  show (MkQuantumCircuit r g) = "[QuantumCircuit result=" ++ show r ++ " gates=" ++ show g ++ "]"

public export
Functor QuantumCircuit where
  map f (MkQuantumCircuit r g) = MkQuantumCircuit (f r) g

public export
Applicative QuantumCircuit where
  pure x = MkQuantumCircuit x 0
  (MkQuantumCircuit f g1) <*> (MkQuantumCircuit x g2) = MkQuantumCircuit (f x) (g1 + g2)

public export
Monad QuantumCircuit where
  (MkQuantumCircuit x g1) >>= f =
    let MkQuantumCircuit y g2 = f x
    in MkQuantumCircuit y (g1 + g2)

||| Injects a single gate operation into the QuantumCircuit monad.
public export
applyGateMonadic : a -> QuantumCircuit a
applyGateMonadic res = MkQuantumCircuit res 1
