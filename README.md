# Idris2-QuantumComputing

Discrete Constructive Quantum Computing, Qubit Circuits, and Entanglement Engine for the **Finite-Science** ecosystem.

## Features

- **Formal Discrete Qubits**: $|\psi\rangle = \alpha|0\rangle + \beta|1\rangle$ over boolean singletons and 4D `Dihedron` phases.
- **Monadic Qubit & Circuit Algebra**: `Functor`, `Applicative`, and `Monad` implementations for `QubitVal` and `QuantumCircuit` enabling monadic `do`-notation circuit building.
- **Quantum Gates & Entanglement**: Pauli-$X$, Pauli-$Z$, Hadamard $H$, CNOT gates, and Bell state $|\Phi^+\rangle$ generation.
- **Quantum Teleportation**: LOCC reconstruction with 100% exact state fidelity.
- **QTT No-Cloning Enforcement**: Compile-time type checking of linear consumption (`1 qubit`) for non-clonability.
- **Landauer Erasure Principle**: Exact thermal multiset lag emission ($\Delta \mathcal{L} \ge 1$).
- **Kitaev Toric Code**: Fault-tolerant surface code stabilizers and non-Abelian anyon braiding phase shift ($-1$).
- **Deutsch-Jozsa Supremacy**: Single-query quantum oracle classification with 100% certainty.

## Build & Install

```bash
toolbox run -c fedora-toolbox-44 /var/home/justin/.local/bin/idris2 --build Idris2-QuantumComputing.ipkg
toolbox run -c fedora-toolbox-44 /var/home/justin/.local/bin/idris2 --install Idris2-QuantumComputing.ipkg
```
