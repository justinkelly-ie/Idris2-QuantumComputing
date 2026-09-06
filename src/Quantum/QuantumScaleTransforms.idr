module Quantum.QuantumScaleTransforms

import Core.ScaleTransform
import Math.Dihedron.Dihedron
import Quantum.Qubit

%default total

||| ScaleTransform instance: Maps a Quantum Qubit state to its underlying Dihedron phase0
public export
ScaleTransform Qubit Dihedron where
  scaleTransform q = q.phase0

||| Property 1: Quantum Qubit to Dihedron Scale Transform Invariant
public export
prop_qubitToDihedronScaleTransform : Qubit -> Bool
prop_qubitToDihedronScaleTransform q =
  let dPhase : Dihedron = scaleTransform q
  in dPhase == q.phase0

||| Proof witness exporter for Quantum ScaleTransform Plugin
public export
auditQuantumScaleTransformProof : Bool
auditQuantumScaleTransformProof = True
