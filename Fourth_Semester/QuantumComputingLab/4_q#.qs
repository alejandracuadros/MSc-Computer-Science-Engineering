namespace QuantumHelloWorld {
    //@EntryPoint ()
    operation HelloWorld () : Unit {
        Message (" Hello world !");
    }
}

/////////// 4.1 Simple circuits
//4.1.1 Quantumbits and gates
//4.1.1.1 Single-bit gates

namespace IntroductiontoQSharp {
    
    open Microsoft.Quantum.Diagnostics ;
    open Microsoft.Quantum.Measurement ;

    //@EntryPoint()
    operation MeasureOneQubit (): Result {
        use q = Qubit ();
        H(q);
        DumpMachine();
        let result = M(q);
        Reset(q);
        return result;
    }

}

//4.1.1.2 Phase-flip
namespace IntroductiontoQSharp {
    
    open Microsoft.Quantum.Diagnostics ;
    open Microsoft.Quantum.Measurement ;    
    //@EntryPoint()
    operation Phaseflip (): Result {
        use q = Qubit ();
        Z(q);
        DumpMachine();
        let result = M(q);
        Reset(q);
        return result;
    }
}
//4.1.1.3 Change of basis and phase-flip
namespace IntroductiontoQSharp {
    
    open Microsoft.Quantum.Diagnostics ;
    open Microsoft.Quantum.Measurement ;    
    //@EntryPoint()
    operation BasisChangeandPhaseFlip (): Result {
        use q = Qubit ();
        H(q);
        Z(q);
        DumpMachine();
        H(q);
        DumpMachine();
        let result = M(q);
        Reset(q);
        return result;
    }
}
//4.1.1.4 Sign switch
namespace IntroductiontoQSharp {
    
    open Microsoft.Quantum.Diagnostics;
    open Microsoft.Quantum.Measurement;

    //@EntryPoint()
    operation SignSwitch(): Result {
        use q = Qubit();
        
        X(q);
        Z(q);
        X(q);

        DumpMachine();
        
        let result = M(q);
        Reset(q);
        return result;
    }
}



//4.1.1.5 Preparing an arbitrary state
namespace IntroductiontoQSharp {
    
    open Microsoft.Quantum.Diagnostics;
    open Microsoft.Quantum.Measurement;
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Math;

    operation PrepareArbitraryState(alpha: Double, theta: Double, q: Qubit): Unit {
        let beta = Sqrt(1.0 - alpha * alpha);

        // Ry to set alpha and beta
        Ry(2.0 * ArcTan2(beta, alpha), q);
        
        // R1 for phase shift
        R1(theta, q);
    }

    //@EntryPoint()
    operation RunExperiment(): Unit {
        use q = Qubit();

        // alpha and theta
        let alpha = 0.6;
        let theta = PI() / 4.0; // π/4

        // transformation
        PrepareArbitraryState(alpha, theta, q);

        DumpMachine();

        let result = M(q);
        Reset(q);
        Message($"Measurement result: {result}");
    }
}


//4.1.1.6 Entanglement

namespace IntroductiontoQSharp {
    
    open Microsoft.Quantum.Diagnostics;
    open Microsoft.Quantum.Measurement;
    open Microsoft.Quantum.Intrinsic;

    //@EntryPoint()
    operation Entanglement(): Unit {
        use q1 = Qubit();
        use q2 = Qubit();
        
        // superposition
        H(q1);
        
        // CNOT - q1 control, q2 target
        CNOT(q1, q2);

        DumpMachine();
        
        let result1 = M(q1);
        let result2 = M(q2);
        
        Reset(q1);
        Reset(q2);
        
        Message($"Measurement: {result1}, {result2}");
    }
}

/////////// 4.2. Random number generation 

// 4.2.1 Generating one random bit

namespace IntroductiontoQSharp {

    open Microsoft.Quantum.Diagnostics;
    open Microsoft.Quantum.Measurement;

    //@EntryPoint()
    operation GenerateRandomBit(): Int {
        use q = Qubit();

        // superposition
        H(q);

        let result = M(q);

        Reset(q);

        // Int result
        return result == Zero ? 0 | 1;
        
    }
}

// 4.2.2 Arbitrary number of random bits

namespace IntroductiontoQSharp {

    open Microsoft.Quantum.Diagnostics;
    open Microsoft.Quantum.Measurement;
    open Microsoft.Quantum.Intrinsic;

    //@EntryPoint()
    operation ArbitraryNumberRandomBits(): Int[] {
        let n = 13; // number of bits to generate
        use qubits = Qubit[n];
        mutable results = [];

        for q in qubits {
            H(q);
            let result = M(q);
            set results += [result == Zero ? 0 | 1]; // INT converter
            Reset(q);
        }

        return results;
    }
}



// 4.2.3 Random number from a given interval

namespace IntroductiontoQSharp {
    
    open Microsoft.Quantum.Diagnostics;
    open Microsoft.Quantum.Measurement;
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Math;

    //@EntryPoint()
    operation RandomNumberGivenInterval(): Int {
        let lowerBound = 10;
        let upperBound = 100;

        let bitSize = BitSizeI(upperBound);
        mutable randomValue = upperBound + 1;

        repeat {
            use qubits = Qubit[bitSize];
            mutable tempValue = 0;

            for i in 0..bitSize - 1 {
                H(qubits[i]);
                let bitResult = M(qubits[i]);
                Reset(qubits[i]);

                if bitResult == One {
                    set tempValue = tempValue + (1 <<< i);
                }
            }

            set randomValue = tempValue;
        } until (randomValue >= lowerBound and randomValue <= upperBound);

        return randomValue;
    }
}

/////////// 4.3
// 4.3.1 Teleportation of a simple state

namespace IntroductiontoQSharp {

    open Microsoft.Quantum.Diagnostics;
    open Microsoft.Quantum.Measurement;
    open Microsoft.Quantum.Intrinsic;

    //@EntryPoint()
    operation TeleportationSimpleState(): Unit {
        use q1 = Qubit(); // Q teleported
        use q2 = Qubit(); // Entangled qubit
        use q3 = Qubit(); // Receiver qubit

        // Bell State
        H(q2);
        CNOT(q2, q3);

        // Teleportation protocol
        CNOT(q1, q2);
        H(q1);

        // Measure q1 and q2
        let m1 = M(q1);
        let m2 = M(q2);

        // Corrections based on classical measurements
        if m2 == One {
            X(q3);
        }
        if m1 == One {
            Z(q3);
        }

        DumpMachine();

        Reset(q1);
        Reset(q2);
        Reset(q3);

        Message($"Measurement: {m1}, {m2}");
    }
}

// 4.3.2 Teleportation of an arbitrary state

namespace IntroductiontoQSharp {

    open Microsoft.Quantum.Diagnostics;
    open Microsoft.Quantum.Measurement;
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Math;

    operation ArbitraryState(alpha: Double, theta: Double, q: Qubit): Unit {
        let beta = Sqrt(1.0 - alpha * alpha);

        // Transformations
        Ry(2.0 * ArcTan2(beta, alpha), q); // Creates alpha|0> + Beta|1>
        R1(theta, q);                      // Phase shift e^(iθ)
    }

    //@EntryPoint()
    operation TeleportArbitraryState(): Unit {
        use q1 = Qubit(); // Qubit to teleport (initialized to |0⟩)
        use q2 = Qubit(); // Entangled qubit
        use q3 = Qubit(); // Receiver qubit

        // Arbitrary quantum state on q1
        let alpha = 0.6;  // Choose alpha (0.6 means beta = 0.8)
        let theta = PI() / 4.0; // Choose phase shift theta (Pi/4)
        PrepareArbitraryState(alpha, theta, q1);
        // Entangled Bell pair
        H(q2);
        CNOT(q2, q3);
        // Teleportation protocol
        CNOT(q1, q2);
        H(q1);
        // Measurement
        let m1 = M(q1);
        let m2 = M(q2);
        // Corrections based on measurements
        if m2 == One {
            X(q3);
        }
        if m1 == One {
            Z(q3);
        }

        DumpMachine();
        Reset(q1);
        Reset(q2);
        Reset(q3);
        Message($"Measurement: {m1}, {m2}");
    }
}


/////////// 4.4 Superdense coding
// 4.4.1 Sending a message

namespace IntroductiontoQSharp {

    open Microsoft.Quantum.Diagnostics;
    open Microsoft.Quantum.Measurement;
    open Microsoft.Quantum.Intrinsic;

    operation EncodingMessage(b1: Int, b2: Int, q: Qubit): Unit {
        if b1 == 1 {
            Z(q); // Z if b1 = 1
        }
        if b2 == 1 {
            X(q); // X if b2 = 1
        }
    }

    operation DecodingMessage(q1: Qubit, q2: Qubit): (Int, Int) {
        // Apply Bell decoding
        CNOT(q1, q2);
        H(q1);

        // Measuring m1 and m2
        let m1 = M(q1);
        let m2 = M(q2);

        return (m1 == One ? 1 | 0, m2 == One ? 1 | 0);
    }

    //@EntryPoint()
    operation SuperdenseCoding(): (Int, Int) {
        use q1 = Qubit();
        use q2 = Qubit();

        // 1: Create Bell Pair
        H(q1);
        CNOT(q1, q2);

        // 2: Alice encodes message
        let b1 = 0;
        let b2 = 0;
        EncodingMessage(b1, b2, q1);

        // 3: Bob decodes message
        let decodedMessage = DecodingMessage(q1, q2);

        DumpMachine();

        Reset(q1);
        Reset(q2);

        Message($"Decoded message:");
        return decodedMessage;
    }
}


// 4.4.2 Sending a random message

namespace IntroductiontoQSharp {
    
    open Microsoft.Quantum.Diagnostics;
    open Microsoft.Quantum.Measurement;
    open Microsoft.Quantum.Intrinsic;

    // Random bit generation
    operation RandomBit(): Int {
        use q = Qubit();
        H(q);
        let result = M(q);
        Reset(q);
        return result == Zero ? 0 | 1;
    }

    // Random bit pairs generation
    operation RandomBitPairs(n: Int): (Int[], Int[]) {
        mutable b1List = [];
        mutable b2List = [];

        for _ in 1..n {
            let b1 = RandomBit();
            let b2 = RandomBit();
            set b1List += [b1];
            set b2List += [b2];
        }

        return (b1List, b2List);
    }

    // Encode (b1, b2) using quantum gates
    operation EncodeMessage(b1: Int, b2: Int, q: Qubit): Unit {
        if b1 == 1 {
            Z(q);
        }
        if b2 == 1 {
            X(q);
        }
    }

    // Decode received qubits
    operation DecodeMessage(q1: Qubit, q2: Qubit): (Int, Int) {
        CNOT(q1, q2);
        H(q1);

        let m1 = M(q1);
        let m2 = M(q2);

        return (m1 == One ? 1 | 0, m2 == One ? 1 | 0);
    }

    //@EntryPoint()
    operation SuperdenseCodingWithRandomMessage(): Unit {
        let n = 10; // bit pairs to send
        let (b1List, b2List) = RandomBitPairs(n);
        mutable receivedList = [];

        for i in 0..n - 1 {
            use q1 = Qubit();
            use q2 = Qubit();

            // 1: Create Bell Pair
            H(q1);
            CNOT(q1, q2);

            // 2: Encode (b1, b2)
            EncodeMessage(b1List[i], b2List[i], q1);

            // 3: Decode
            let received = DecodeMessage(q1, q2);
            set receivedList += [received];

            Reset(q1);
            Reset(q2);
        }

        // Compare messages
        Message($"Original Message: {b1List}, {b2List}");
        Message($"Received Message: {receivedList}");
    }
}


/////////// 4.5 Extra exercise: Deutsch-Jozsa algorithm
namespace DeutschJozsa {
    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Diagnostics;
    open Microsoft.Quantum.Math;
    open Microsoft.Quantum.Measurement;
    open Microsoft.Quantum.Intrinsic;

    @EntryPoint()
    operation Main(): Unit {
        let n = 5;
        let isConstant = DeutschJozsa(SimpleBalancedBoolF, n);
        let isConstantStr = isConstant ? "constant" | "balanced";
        Message($"The function is {isConstantStr}");
    }

    // Deutsch-Jozsa Algorithm
    operation DeutschJozsa(Uf: ((Qubit[], Qubit) => Unit), n: Int): Bool {
        use register = Qubit[n];
        use target = Qubit();

        // Initialize target qubit to |1> by applying X and H
        X(target);
        H(target);

        // Apply Hadamard to all qubits
        for q in register {
            H(q);
        }

        // Apply the given function Uf
        Uf(register, target);

        // Apply Hadamard again to all input qubits
        for q in register {
            H(q);
        }

        // Measure all input qubits
         let results = [for q in register -> M(q)];

        // If all measurements are |0>, the function is constant, otherwise balanced
        return all(r == Zero for r in results);
    }

    // Simple constant function
    operation SimpleConstantBoolF(args: Qubit[], target: Qubit): Unit {
        X(target);
    }

    // Simple balanced function
    operation SimpleBalancedBoolF(args: Qubit[], target: Qubit): Unit {
        CX(args[0], target);
    }

    // Complex constant function
    operation ConstantBoolF(args: Qubit[], target: Qubit): Unit {
        for i in 0..(2^Length(args)) - 1 {
            ApplyControlledOnInt(i, X, args, target);
        }
    }

    // Complex balanced function
    operation BalancedBoolF(args: Qubit[], target: Qubit): Unit {
        for i in 0..2..(2^Length(args)) - 1 {
            ApplyControlledOnInt(i, X, args, target);
        }
    }
}
