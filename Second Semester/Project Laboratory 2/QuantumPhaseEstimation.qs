namespace QuantumPhaseEstimation {
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Measurement;

    operation ApplyControlledU(register : Qubit[], target : Qubit, power : Int) : Unit is Adj + Ctl {
    }

    
    operation InverseQFT(register : Qubit[]) : Unit is Adj {

    }
    
// DEFINE U, THIS COUKD BE PAULI X GATE 
// START WITH KET 0 

//matrix is two vectors, the code register variable with 4 parameters. we need to give values 
//Define the ket 0
// give values to the register , two vectors. 
// register upper and lower section (investigate)  --> Define it 
//2 qubits, two registers, 
// define it in the code

// check if its upper or combined?

// Possible to apply a control u transformation? is there any function that can elaborate the controlled u operation?  FUNCTION ?
// check it.

// FOR SORTING. Quantum Sorting.

// Check Qiskit for PE.


    @EntryPoint()
    operation QuantumPhaseEstimation() : Result[] {
        let numQubits = 4; // Number of qubits in the register
        use register = Qubit[numQubits];
        use target = Qubit();

        // Pauli x Gate 
        X(target);

        // Apply Hadamard gates to the register qubits
        ApplyToEach(H, register);

        // Apply controlled-U operations
        for idx in 0..numQubits - 1 {
            let power = 2^idx;
            ApplyControlledU(register[idx..idx], target, power);
        }

        // Apply inverse QFT
        InverseQFT(register);

        // Measure the register qubits and specify the type of resultArray
        mutable results : Result[]= Result[Length(register)]; 
        //initializes a mutable array named results to store measurement outcomes from each qubit in a quantum register
        // array size matching the number of qubits.
        for (index in 0..Length(register) - 1) {
            set results w/= index <- M(register[index]);
        }
    
        // Reset all qubits before deallocating them
        ResetAll(register + [target]);

        return results;
    }
}
