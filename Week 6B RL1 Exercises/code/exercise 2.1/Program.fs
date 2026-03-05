// Define states
type State = S0 | S5 | S10 | S15 | ERROR

// Define letters
type Letter = KR5 | KR10 | TEA | COFFEE

// Define edges/transitions
let nextState state symbol =
    match state, symbol with
    // From state S0
    | S0, KR5       -> S5
    | S0, KR10      -> S10
    | S0, TEA       -> ERROR
    | S0, COFFEE    -> ERROR
    // From state S5
    | S5, KR5       -> S10
    | S5, KR10      -> S15
    | S5, TEA       -> ERROR
    | S5, COFFEE    -> ERROR
    // From state S10
    | S10, KR5       -> S15
    | S10, KR10      -> ERROR
    | S10, TEA       -> S0
    | S10, COFFEE    -> ERROR
    // From state S15
    | S15, KR5       -> ERROR
    | S15, KR10      -> ERROR
    | S15, TEA       -> ERROR
    | S15, COFFEE    -> S0
    // From state ERROR
    | ERROR, KR5       -> ERROR
    | ERROR, KR10      -> ERROR
    | ERROR, TEA       -> ERROR
    | ERROR, COFFEE    -> ERROR

// Run the automaton sequantially for each letter
let rec run state input =
    match input with
    | [] -> state
    | symbol:: more -> run (nextState state symbol) more

// Print final state
printfn "Running ...\nFinished at state %A" ( run S0 ( KR5 :: KR10 :: COFFEE ::[]))