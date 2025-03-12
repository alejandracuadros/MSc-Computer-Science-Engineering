namespace QuantumHelloWorld {
    @EntryPoint ()
    operation HelloWorld () : Unit {
        Message (" Hello world !");
    }
}

// 4.1 Simple circuits
//4.1.1 Quantumbits and gates




namespace IntroductiontoQSharp {
    
    open Microsoft.Quantum.Diagnostics ;
    open Microsoft.Quantum.Measurement ;

    @EntryPoint()
    operation MeasureOneQubit (): Result {
        use q = Qubit ();
        H(q);
        DumpMachine();
        let result = M(q);
        Reset(q);
        return result;
    }
}
