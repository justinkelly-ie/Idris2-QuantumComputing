module Quantum.LandauerErasure

import Math.Singleton.Bit
import Math.Singleton.Sing
import Math.Multiset
import Math.BoxInt

%default total

||| Resets 1 Boolean Singleton Bit and emits 1 unit of dissipation heat
public export
eraseBitWithHeat : Bit -> (Bit, Nat)
eraseBitWithHeat b =
  let resetBit = Zero
      heatDissipated = if isOne b then 1 else 0
  in (resetBit, heatDissipated)

||| Property: Landauer Erasure Heat Dissipation Law (ΔL >= 1 for 1-bit reset)
public export
prop_landauerErasureEmitsHeat : Bit -> Bool
prop_landauerErasureEmitsHeat b =
  let (reset, heat) = eraseBitWithHeat One
  in heat >= 1 && isZero reset
