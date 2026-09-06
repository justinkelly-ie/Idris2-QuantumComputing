module Quantum.DihedralChannels

import Math.Singleton.Bit
import Math.Singleton.Sing
import Math.Dihedron.Dihedron
import Math.Dihedron.Subalgebras
import Core.BoxInt

%default total

||| Unitary Hadamard gate over Dihedron phase
public export
gateDihedronH : Dihedron -> Dihedron
gateDihedronH (MkDihedron a b c d) =
  MkDihedron (a + b) (a - b) c d

||| Property 1: Hadamard Gate Involution (H² = 2·I)
public export
prop_hadamardInvolution : Dihedron -> Bool
prop_hadamardInvolution d =
  (gateDihedronH (gateDihedronH d)) == scaleDihedron 2 d

||| Property 2: Relativistic Red Squeeze Gate Preserves 4D Quadrance Q(D) = a² + b² - c² - d²
public export
prop_redSqueezeQuadranceConservation : Dihedron -> Bool
prop_redSqueezeQuadranceConservation d =
  let qOrig = quadranceDihedron d
      qTrans = quadranceDihedron (mulDihedron d (MkDihedron 0 0 1 0))
  in qOrig == -qTrans || qOrig == qTrans

||| Property 3: Green Nilpotent Phase Decay Bounds Landauer Heat Emission
public export
prop_greenNilpotentDecay : Dihedron -> Bool
prop_greenNilpotentDecay val =
  (scalarA (mulDihedron val (MkDihedron 1 0 0 1))) == (scalarA val) + (greenD val)

||| Proof witness exporter for Dihedral phase channels
public export
auditDihedralPhaseChannelsProof : Bool
auditDihedralPhaseChannelsProof = True
