namespace SuperdenseCoding {

    // Import libraries required for code
    open Microsoft.Quantum.Intrinsic; // Basic Operations
    open Microsoft.Quantum.Canon; //Advanced Operarions

    // Create a entangled pair of qubits
    operation CreateEntangledPair(qubit1 : Qubit, qubit2 : Qubit) : Unit {
        H(qubit1); // Apply Hadamard gate to the first qubit
        CNOT(qubit1, qubit2); // Entangle the first qubit with the second qubit
    }

    // Operation for Alice to encode her message onto her qubit
    operation EncodeMessage(qubit : Qubit, message : (Bool, Bool)) : Unit {
        if (message == (true, true)) {
            // Apply Z gate then X gate for the message 11
            X(qubit);
            Z(qubit);
        } elif (message == (true, false)) {
            // Apply Z gate for the message 10
            Z(qubit);
        } elif (message == (false, true)) {
            // Apply X gate for the message 01
            X(qubit);
        } elif (message == (false,false)) {
            // If the message is 00, do nothing
        }
    }

    // Operation for Bob to decode the message sent by Alice
    operation DecodeMessage(qubit1 : Qubit, qubit2 : Qubit) : (Bool, Bool) {
        CNOT(qubit1, qubit2);
        H(qubit1);

        // Measure both qubits
        let bit1 = M(qubit1) == One ? true | false;
        let bit2 = M(qubit2) == One ? true | false;

        // Return the decoded message
        return (bit1, bit2);
    }

    // Entry point operation to run the superdense coding protocol
    @EntryPoint()
    operation RunSuperdenseCoding() : Unit {
        let messageToSend = (false, true); // Message Alice wants to send
        use qubits = Qubit[2] {
            // Step 1: Create an entangled pair of qubits
            CreateEntangledPair(qubits[0], qubits[1]);

            // Step 2: Alice encodes her message onto her qubit
            EncodeMessage(qubits[0], messageToSend);

            // Step 3: Bob decodes the message
            let receivedMessage = DecodeMessage(qubits[0], qubits[1]);

            // Print out the result
            Message($"Message sent by Alice: {messageToSend}");
            Message($"Message received by Bob: {receivedMessage}");

            // Reset qubits to their |0⟩ state
            ResetAll(qubits);
        }
    }

}
