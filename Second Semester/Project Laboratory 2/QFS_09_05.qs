namespace QuantumPhaseEstimationExample {
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Canon;
 
    // Define a simple phase oracle
    operation PhaseOracle(target : Qubit) : Unit is Adj + Ctl {
        // Define π using ArcTan2
        let PI = 3.1415926535897932384626433832795028841971;
        let phase = PI / 4.0;  // Example phase
        R1(phase, target);
    }

    // Manual implementation of Quantum Phase Estimation
    operation QuantumPhaseEstimationManual(target : Qubit, register : Qubit[]) : Double {
        let numQubits = Length(register);
        ApplyToEach(H, register);
        for (index in 0 .. numQubits - 1) {
            Controlled PhaseOracle([register[idx]], target);
        }
        Adjoint QFT(register);
        let result = MeasureInteger(LittleEndian(register));
        ResetAll(register);
        return IntAsDouble(result) / (2.0 ^ numQubits);
    }

    @EntryPoint()
    operation RunQuantumPhaseEstimation() : Unit {
        use (target = Qubit(), register = Qubit[3]) {
            let phaseEstimationResult = QuantumPhaseEstimationManual(target, register);
            Message($"Estimated phase (in radians): {phaseEstimationResult * 2.0 * PI}");
        }
    }
}
