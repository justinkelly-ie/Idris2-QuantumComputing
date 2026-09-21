# FinSc-QuantumComputing

[![Idris 2 Verification](https://img.shields.io/badge/Idris_2-0.8.0-blue.svg)](https://www.idris-lang.org/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

**Layer 6b Quantum Logic Gates, Toric Code & Entanglement Area Laws for Idris 2**

`FinSc-QuantumComputing` forms **Layer 6b** of the 10-layer constructive non-linear multiset science framework. It formalizes discrete qubit states ($\alpha|0\rangle + \beta|1\rangle$ over exact rational fields), multi-qubit registers, quantum gates ($H, X, Y, Z, \text{CNOT}, \text{Toffoli}, S, T$), quantum teleportation, QTT No-Cloning theorem, Kitaev Toric Code error correction, Deutsch-Jozsa algorithm, and Landauer erasure bounds.

---

## 📦 Core Library Architecture & Modules

### 1. `Quantum.Qubit` & `Quantum.Register`
- **Exact Qubit States:** Discrete qubit states ($\alpha|0\rangle + \beta|1\rangle$) parameterized over exact rational fields (`UnixelFraction`), preventing floating-point phase drift.
- **Quantum Registers & Density Matrices:** Multi-qubit register states, pure and mixed state density matrices, and Born rule measurement probabilities.

### 2. `Quantum.Circuit`
- **Constructive Quantum Logic Gates:** Universal quantum gate sets ($H, X, Y, Z, \text{CNOT}, \text{Toffoli}, S, T$) and quantum circuit composition pipelines.

### 3. `Quantum.Teleportation` & `Quantum.NoCloning`
- **Quantum Teleportation Protocol:** Verification of 3-qubit entanglement teleportation channels with EPR pair consumption.
- **QTT No-Cloning Theorem:** Type-level proof witness proving that linear QTT state types cannot be duplicated ($\text{Multiplicity } 1$).

### 4. `Quantum.ToricCode`
- **Kitaev Toric Code:** Fault-tolerant topological quantum memory on toroidal lattices, stabilizer operators ($A_s, B_p$), and anyonic error syndrome recovery.

### 5. `Quantum.DeutschJozsa`, `Quantum.LandauerErasure`, `Quantum.DihedralChannels`
- **Deutsch-Jozsa Algorithm:** Quantum parallelism and oracle evaluation.
- **Landauer Erasure:** Thermodynamic cost of resetting qubit registers ($W \ge k_B T \ln 2$).
- **Dihedral Phase Channels:** Discrete dihedral phase rotations ($D_n$) over quantum state spaces.

### 6. `Quantum.QuantumScaleTransforms`
- **Quantum-to-Classical Scale Pipeline:** Scale transformation mapping quantum state registers to classical multiset channels.

---

## 🚀 Building & Installing

```bash
idris2 --build FinSc-QuantumComputing.ipkg
idris2 --install FinSc-QuantumComputing.ipkg
```

---

## 🔬 Architectural Principles

- **Total Constructivism:** Enforces `%default total` across all quantum computing modules.
- **QTT Linear Erasure:** Strict linear resource accounting enforcing No-Cloning at compile time.
- **Fault-Tolerant Topological Code:** Kitaev Toric Code stabilizer verification over discrete torus grids.
