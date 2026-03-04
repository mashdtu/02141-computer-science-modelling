#import "@preview/diagraph:0.3.6": *

#show heading: set block(above: 2em)
#show heading: set block(below: 1em)
#show link: it => underline(text(fill: blue)[#it])
#show heading.where(level: 3): set heading(outlined: false)

#set page(
    paper: "a4",
    margin: (x: 2.5cm, y: 2.5cm),
    numbering: "1 of 1",
    number-align: right,
    header: none
)

#set par(
    justify: true,
)

#set text(
    font: "New Computer Modern",
    size: 12pt
)

#set heading(
    numbering: "1.1 ",
)

#let ansline = line(
    start: (0%, 0%),
    end: (100%, 0%),
    stroke: (thickness: 1pt, dash: "dashed")
)

#let title = "Regular Languages 1"
#let subtitle = "Deterministic Finite Automata (DFA)"
#let subject = "02141 Computer Science Modelling"
#let date = "February 3rd, 2026"

#let author = (if read("../.secret").trim() == "" { "name" } else { read("../.secret").trim() },)

#align(center)[
    #text(32pt)[#smallcaps(title)] \ #text(18pt)[#subtitle] \ #text(fill:black.lighten(25%), [#subject])
]

#{
    grid(columns: (1fr,) * author.len(),
        column-gutter: 2pt,
        ..author.map(a => align(center)[#a])
    )
}

#align(center)[
    #date
]


//#pagebreak()
#outline()

//#v(16pt)
//#grid(columns: (1cm, 1fr, 1cm),
//    column-gutter: 2pt,
//    [],
//    [],
//    []
//)

    

#pagebreak()


= Exercise RL1.1. Building DFA's.
Give DFA's accepting the following languages over the alphabet ${0, 1}$:

== The set of all strings ending in $00$.
#align(center, [
    #raw-render(```
        digraph {
            node [shape = circle]
            rankdir=LR
            g [shape=point, width=0]
            s[label="q_circle", math=true]
            s1[label="q_1"]
            sf[label="q_circle.filled", math=true, shape = doublecircle]
            g -> s
            s -> s [label="1"]
            s -> s1 [label="0"]
            s1 -> s [label="1"]
            s1 -> sf [label="0"]
            sf -> s [label="1"]
            sf -> sf [label="0"]
        }
    ```)
])

== The set of all strings with three consecutive $0$'s (not necissarily at the end).
#align(center, [
    #raw-render(```
        digraph {
            node [shape = circle]
            rankdir=LR
            g [shape=point, width=0]
            s[label="q_circle", math=true]
            s1[label="q_1"]
            s2[label="q_2"]
            sf[label="q_circle.filled", math=true, shape = doublecircle]
            g -> s
            s -> s [label=1]
            s -> s1 [label=0]
            s1 -> s2 [label=0]
            s2 -> sf [label=0]
            s1 -> s [label=1]
            s2 -> s [label=1]
            sf -> sf [label="0,1"]
        }
    ```)
])


== The set of strings with $011$ as a substring.
#align(center, [
    #raw-render(```
        digraph {
            node [shape = circle]
            rankdir=LR
            g [shape=point, width=0]
            s[label="q_circle", math=true]
            s1[label="q_1"]
            s2[label="q_2"]
            sf[label="q_circle.filled", math=true, shape = doublecircle]
            g -> s
            s -> s [label=1]
            s -> s1 [label=0]
            s1 -> s2 [label=1]
            s2 -> sf [label=1]
            s1 -> s1 [label=0]
            s2 -> s1 [label=0]
            sf -> sf [label="0,1"]
        }
    ```)
])



#pagebreak()
= Exercise RL1.2. Vending Machine in F\#.
#align(center, [
    #image("assets/image.png", width: 50%)
])

== Implement the above DFA of a vending machine in F\#.
#raw(read("code/exercise 2.1/Program.fs"), lang: "fs")




#pagebreak()
= Exercise RL1.3 Extension of the Vending Machine
== Extend the vending machine of the previous exercise to offer chocolate at a price of 20kr and to accept 20kr coins as well.

#align(center, [
    #raw-render(width: 100%, ```
        digraph {
            node [shape = circle]
            rankdir=LR
            g [shape=point, width=0]
            s[label="0"]
            s1[label="5"]
            s2[label="10"]
            s3[label="15"]
            s4[label="20"]
            sf[label="Error", shape = doublecircle]
            g -> s
            s -> s1[label="5kr"]
            s -> s2[label="10kr"]
            s -> s4[label="20kr"]
            s -> sf[label="coffee, tea"]

            s1 -> s2[label="5kr"]
            s1 -> s3[label="10kr"]
            s1 -> sf[label="20kr, coffee, tea"]

            s2 -> s3[label="5kr"]
            s2 -> s[label="tea"]
            s2 -> s4[label="10kr"]
            s2 -> sf[label="20kr, coffee"]

            s3 -> s[label="coffee"]
            s3 -> s4[label="5kr"]
            s3 -> sf[label="10kr, 20kr, tea"]

            s4 -> s[label="Chocolate"]
            s4 -> sf[label="5kr, 10kr, 20kr, coffee, tea"]

            sf -> sf[label="5kr, 10kr, 20kr, chocolate, coffee, tea,"]
        }
    ```)
])

The automaton can be implemented in F\# as follows: 
#raw(read("code/exercise 2.2/Program.fs"), lang: "fs")




#pagebreak()
= Exercise RL1.4. $2 times 2$ puzzle.

== Model the $2 times 2$ puzzle, the simplest form of the $N times N$ puzzle (https://en.wikipedia.org/wiki/15_puzzle) with a DFA. Which sequences of transitions help you solve the puzzle.
(Copied from solutions) -- The following DFA models the entire puzzle. For simplicity we use the compact representation with an implicit error state that we do not depict (missing transitions all lead to that state). The states are the possible placement of the tiles (1, 2 and 3) and the hole (denoted with a blank space). The actions are up, down, left, right and correspond to moving a tile to the hole. Note that there are two disconnected parts in the automaton. The one above is the actual one that you can play regularly. The one below is one that you could obtain by physically extracting a tile from the board and replacing it by an adjacent one. In the new board obtained there is no way to solve the puzzle.

#align(center, [
    #grid(columns: 2, gutter: 10pt, 
        image("assets/image-3.png", width: 100%),
        image("assets/image-4.png", width: 100%)
    )
])





#pagebreak()
= Exercise RL1.5. Wolf-goat-cabbage.
Model the classical river-crossing puzzle "wolf, goat and cabbage" (https://en.wikipedia.org/wiki/Wolf,_goat_and_cabbage_problem) with DFA.

== Model each of the four individuals (ferrymand, goat, cabbage and wolf) as a separate individual DFA.
For each of the four DFAs we have the following four actions:

- `WF`: Wolf and Ferryman cross the river.
- `GF`: Goat and Ferryman cross the river.
- `CF`: cabbage and Ferryman cross the river.
- `F`: Ferryman crosses the river alone.

#align(center, [
    #grid(columns: 4, gutter: 12pt, 
        raw-render(width: 100%, ```
            digraph {
                rankdir=LR
                node [shape = circle]
                g [shape=point, width=0]
                s0[label="w_0", math=on]
                s1[label="w_1", math=on, shape=doublecircle]
                g -> s0
                s0 -> s1[label="WF"]
                s0 -> s0[label="GF, CF, F"]
                s1 -> s0[label="WF"]
                s1 -> s1[label="GF, CF, F"]
            }
        ```),
        raw-render(width: 100%, ```
            digraph {
                rankdir=LR
                node [shape = circle]
                g [shape=point, width=0]
                s0[label="g_0", math=on]
                s1[label="g_1", math=on, shape=doublecircle]
                g -> s0
                s0 -> s1[label="GF"]
                s0 -> s0[label="WF, CF, F"]
                s1 -> s0[label="GF"]
                s1 -> s1[label="WF, CF, F"]
            }
        ```),
        raw-render(width: 100%, ```
            digraph {
                rankdir=LR
                node [shape = circle]
                g [shape=point, width=0]
                s0[label="c_0", math=on]
                s1[label="c_1", math=on, shape=doublecircle]
                g -> s0
                s0 -> s1[label="CF"]
                s0 -> s0[label="WF, GF, F"]
                s1 -> s0[label="CF"]
                s1 -> s1[label="WF, GF, F"]
            }
        ```),
        raw-render(width: 100%, ```
            digraph {
                rankdir=LR
                node [shape = circle]
                g [shape=point, width=0]
                s0[label="f_0", math=on]
                s1[label="f_1", math=on, shape=doublecircle]
                g -> s0
                s0 -> s1[label="WF, GF, CF, F"]
                s1 -> s0[label="WF, GF, CF, F"]
            }
        ```)
    )
])


== Model the entire puzzle as the DFA that results from the product (intersection) of all 4 DFA.

The product automaton has $2^4 = 16$ states and can be illustrated as follows:
#raw-render(width: 100%, ```
    digraph {
        rankdir=LR
        node [shape = circle]
        g [shape=point, width=0]
        0000[label="w_0 g_0 c_0 f_0"]
        0001[label="w_0 g_0 c_0 f_1"]
        0010[label="w_0 g_0 c_1 f_0"]
        0011[label="w_0 g_0 c_1 f_1"]
        0100[label="w_0 g_1 c_0 f_0"]
        0101[label="w_0 g_1 c_0 f_1"]
        0110[label="w_0 g_1 c_1 f_0"]
        0111[label="w_0 g_1 c_1 f_1"]
        1000[label="w_1 g_0 c_0 f_0"]
        1001[label="w_1 g_0 c_0 f_1"]
        1010[label="w_1 g_0 c_1 f_0"]
        1011[label="w_1 g_0 c_1 f_1"]
        1100[label="w_1 g_1 c_0 f_0"]
        1101[label="w_1 g_1 c_0 f_1"]
        1110[label="w_1 g_1 c_1 f_0"]
        1111[label="w_1 g_1 c_1 f_1", shape=doublecircle]
        g -> 0000

        // 0 0 0 0
        0000 -> 1001[label="WF"]
        0000 -> 0101[label="GF"]
        0000 -> 0011[label="CF"]
        0000 -> 0001[label="F"]
        
        // 0 0 0 1
        0001 -> 0000[label="F"]


        // 0 0 1 0
        0010 -> 1011[label="WF"]
        0010 -> 0111[label="GF"]
        0010 -> 0011[label="F"]

        // 0 0 1 1
        0011 -> 0000[label="CF"]
        0011 -> 0010[label="F"]
        
        // 0 1 0 0
        0100 -> 1101[label="WF"]
        0100 -> 0111[label="CF"]
        0100 -> 0101[label="F"]

        // 0 1 0 1
        0101 -> 0000[label="GF"]
        0101 -> 0100[label="F"]

        // 0 1 1 0
        0110 -> 1111[label="WF"]
        0110 -> 0111[label="F"]
        
        // 0 1 1 1
        0111 -> 0010[label="GF"]
        0111 -> 0100[label="CF"]
        0111 -> 0110[label="F"]

        // 1 0 0 0
        1000 -> 1101[label="GF"]
        1000 -> 1011[label="CF"]
        1000 -> 1001[label="F"]
        
        // 1 0 0 1
        1001 -> 0000[label="WF"]
        1001 -> 1000[label="F"]

        // 1 0 1 0
        1010 -> 1111[label="GF"]
        1010 -> 1011[label="F"]

        // 1 0 1 1
        1011 -> 0010[label="WF"]
        1011 -> 1000[label="CF"]
        1011 -> 1010[label="F"]

        // 1 1 0 0
        1100 -> 1111[label="CF"]
        1100 -> 1101[label="F"]

        // 1 1 0 1
        1101 -> 0100[label="WF"]
        1101 -> 1000[label="GF"]
        1101 -> 1100[label="F"]

        // 1 1 1 0
        1110 -> 1111[label="F"]

        // 1 1 1 1
        1111 -> 0110[label="WF"]
        1111 -> 1010[label="GF"]
        1111 -> 1100[label="CF"]
        1111 -> 1110[label="F"]
    }
```)


#pagebreak()
== Identify the "bad" states of the puzzle (where an individual can eat another one).
The "bad" states are coloured in red in the following illustration of the DFA.
#raw-render(width: 100%, ```
    digraph {
        rankdir=LR
        node [shape = circle]
        g [shape=point, width=0]
        0000[label="w_0 g_0 c_0 f_0"]
        0001[label="w_0 g_0 c_0 f_1", color=red]
        0010[label="w_0 g_0 c_1 f_0"]
        0011[label="w_0 g_0 c_1 f_1", color=red]
        0100[label="w_0 g_1 c_0 f_0"]
        0101[label="w_0 g_1 c_0 f_1"]
        0110[label="w_0 g_1 c_1 f_0", color=red]
        0111[label="w_0 g_1 c_1 f_1"]
        1000[label="w_1 g_0 c_0 f_0"]
        1001[label="w_1 g_0 c_0 f_1", color=red]
        1010[label="w_1 g_0 c_1 f_0"]
        1011[label="w_1 g_0 c_1 f_1"]
        1100[label="w_1 g_1 c_0 f_0", color=red]
        1101[label="w_1 g_1 c_0 f_1"]
        1110[label="w_1 g_1 c_1 f_0", color=red]
        1111[label="w_1 g_1 c_1 f_1", shape=doublecircle]
        g -> 0000

        // 0 0 0 0
        0000 -> 1001[label="WF"]
        0000 -> 0101[label="GF"]
        0000 -> 0011[label="CF"]
        0000 -> 0001[label="F"]
        
        // 0 0 0 1
        0001 -> 0000[label="F"]


        // 0 0 1 0
        0010 -> 1011[label="WF"]
        0010 -> 0111[label="GF"]
        0010 -> 0011[label="F"]

        // 0 0 1 1
        0011 -> 0000[label="CF"]
        0011 -> 0010[label="F"]
        
        // 0 1 0 0
        0100 -> 1101[label="WF"]
        0100 -> 0111[label="CF"]
        0100 -> 0101[label="F"]

        // 0 1 0 1
        0101 -> 0000[label="GF"]
        0101 -> 0100[label="F"]

        // 0 1 1 0
        0110 -> 1111[label="WF"]
        0110 -> 0111[label="F"]
        
        // 0 1 1 1
        0111 -> 0010[label="GF"]
        0111 -> 0100[label="CF"]
        0111 -> 0110[label="F"]

        // 1 0 0 0
        1000 -> 1101[label="GF"]
        1000 -> 1011[label="CF"]
        1000 -> 1001[label="F"]
        
        // 1 0 0 1
        1001 -> 0000[label="WF"]
        1001 -> 1000[label="F"]

        // 1 0 1 0
        1010 -> 1111[label="GF"]
        1010 -> 1011[label="F"]

        // 1 0 1 1
        1011 -> 0010[label="WF"]
        1011 -> 1000[label="CF"]
        1011 -> 1010[label="F"]

        // 1 1 0 0
        1100 -> 1111[label="CF"]
        1100 -> 1101[label="F"]

        // 1 1 0 1
        1101 -> 0100[label="WF"]
        1101 -> 1000[label="GF"]
        1101 -> 1100[label="F"]

        // 1 1 1 0
        1110 -> 1111[label="F"]

        // 1 1 1 1
        1111 -> 0110[label="WF"]
        1111 -> 1010[label="GF"]
        1111 -> 1100[label="CF"]
        1111 -> 1110[label="F"]
    }
```)




== Identify a sequence of actions (a string) that solves the puzzle (i.e. everyone safely crosses the river).
The solution to the puzzle is the following:

1. Take the goat over
2. Return empty-handed
3. Take the wolf or cabbage over
4. Return with the goat
5. Take whichever was not taken in step 3 over
6. Return empty-handed
7. Take the goat over

This can be expressed as the following strings in the DFA's alphabet:

#align(center, [
    #text(fill: blue, [`GF F WF GF CF F GF`])
    #h(6pt) and #h(6pt)
    #text(fill: blue, [`GF F`]) #text(fill: green, [`CF GF WF`]) #text(fill: blue, [`F GF`]).
])

The solutions are highlighted in the illustration below with blue and green edges.
#raw-render(width: 100%, ```
    digraph {
        rankdir=LR
        node [shape = circle]
        g [shape=point, width=0]
        0000[label="w_0 g_0 c_0 f_0"]
        0001[label="w_0 g_0 c_0 f_1", color=red]
        0010[label="w_0 g_0 c_1 f_0"]
        0011[label="w_0 g_0 c_1 f_1", color=red]
        0100[label="w_0 g_1 c_0 f_0"]
        0101[label="w_0 g_1 c_0 f_1"]
        0110[label="w_0 g_1 c_1 f_0", color=red]
        0111[label="w_0 g_1 c_1 f_1"]
        1000[label="w_1 g_0 c_0 f_0"]
        1001[label="w_1 g_0 c_0 f_1", color=red]
        1010[label="w_1 g_0 c_1 f_0"]
        1011[label="w_1 g_0 c_1 f_1"]
        1100[label="w_1 g_1 c_0 f_0", color=red]
        1101[label="w_1 g_1 c_0 f_1"]
        1110[label="w_1 g_1 c_1 f_0", color=red]
        1111[label="w_1 g_1 c_1 f_1", shape=doublecircle]
        g -> 0000

        // 0 0 0 0
        0000 -> 1001[label="WF"]
        0000 -> 0101[label="GF", color=blue]
        0000 -> 0011[label="CF"]
        0000 -> 0001[label="F"]
        
        // 0 0 0 1
        0001 -> 0000[label="F"]


        // 0 0 1 0
        0010 -> 1011[label="WF", color=green]
        0010 -> 0111[label="GF"]
        0010 -> 0011[label="F"]

        // 0 0 1 1
        0011 -> 0000[label="CF"]
        0011 -> 0010[label="F"]
        
        // 0 1 0 0
        0100 -> 1101[label="WF", color=blue]
        0100 -> 0111[label="CF", color=green]
        0100 -> 0101[label="F"]

        // 0 1 0 1
        0101 -> 0000[label="GF"]
        0101 -> 0100[label="F", color=blue]

        // 0 1 1 0
        0110 -> 1111[label="WF"]
        0110 -> 0111[label="F"]
        
        // 0 1 1 1
        0111 -> 0010[label="GF", color=green]
        0111 -> 0100[label="CF"]
        0111 -> 0110[label="F"]

        // 1 0 0 0
        1000 -> 1101[label="GF"]
        1000 -> 1011[label="CF", color=blue]
        1000 -> 1001[label="F"]
        
        // 1 0 0 1
        1001 -> 0000[label="WF"]
        1001 -> 1000[label="F"]

        // 1 0 1 0
        1010 -> 1111[label="GF", color=blue]
        1010 -> 1011[label="F"]

        // 1 0 1 1
        1011 -> 0010[label="WF"]
        1011 -> 1000[label="CF"]
        1011 -> 1010[label="F", color=blue]

        // 1 1 0 0
        1100 -> 1111[label="CF"]
        1100 -> 1101[label="F"]

        // 1 1 0 1
        1101 -> 0100[label="WF"]
        1101 -> 1000[label="GF", color=blue]
        1101 -> 1100[label="F"]

        // 1 1 1 0
        1110 -> 1111[label="F"]

        // 1 1 1 1
        1111 -> 0110[label="WF"]
        1111 -> 1010[label="GF"]
        1111 -> 1100[label="CF"]
        1111 -> 1110[label="F"]
    }
```)




#pagebreak()
= Exercise RL1.6. Understanding DFAs.
Consider the DFA with the following transition table:

#table(
    columns: (1fr, 1fr, 1fr),
    [], [0], [1],
    [$-> A$], [$A$], [$B$],
    [$* B$], [$B$], [$A$]
)

== Informally describe the language accepted by this DFA, and prove by induction on the length of an input string that your description is correct. _Hint_: When setting up the inductive hypothesis, it is wise to make a statement about what inputs get you to each state, not just what inputs get you to the accepting state.

The DFA can be illustrated as follows:
#align(center, [
    #raw-render(```
        digraph {
            rankdir=LR
            node [shape = circle]
            g [shape=point, width=0]
            s [label="A"]
            sf [label="B", shape=doublecircle]

            g -> s
            s -> s[label="0"]
            s -> sf[label="1"]
            sf -> sf[label="0"]
            sf -> s[label="1"]
        }
    ```)
])
The language $L$ accepted by this DFA is the set of all strings over ${0, 1}$ containing an odd number of 1's. I.e.
$
    L = { w in {0, 1}^* | |w|_1 equiv 1 mod 2 }
$
where $|w|_1$ denotes the number of 1's in string $w$. This can be proven by induction:

*Claim:* For any string $w in {0, 1}^*$,
- $hat(delta)(A, w) = A$ if and only if $|w|_1$ is even.
- $hat(delta)(A, w) = B$ if and only if $|w|_1$ is odd.

*Base Case:* $|w| = 0$, i.e., $w = epsilon$ (empty string).

For the empty string: $hat(delta)(A, epsilon) = A$ by definition, and $|epsilon|_1 = 0$, which is even.

*Inductive Step:* Assume the claim holds for all strings of length $n$. Consider a string $w$ of length $n + 1$. We can write $w = x a$ where $|x| = n$ and $a in {0, 1}$.

By the definition of the transition function: $hat(delta)(A, x a) = delta(hat(delta)(A, x), a)$

*Case 1:* $a = 0$
- If $hat(delta)(A, x) = A$: Then $delta(A, 0) = A$, so $hat(delta)(A, w) = A$. By IH, $|x|_1$ is even, and since $a = 0$, we have $|w|_1 = |x|_1 + 0 =$ even.
- If $hat(delta)(A, x) = B$: Then $delta(B, 0) = B$, so $hat(delta)(A, w) = B$. By IH, $|x|_1$ is odd, and since $a = 0$, we have $|w|_1 = |x|_1 + 0 =$ odd.

*Case 2:* $a = 1$
- If $hat(delta)(A, x) = A$: Then $delta(A, 1) = B$, so $hat(delta)(A, w) = B$. By IH, $|x|_1$ is even, and since $a = 1$, we have $|w|_1 = |x|_1 + 1 =$ odd.
- If $hat(delta)(A, x) = B$: Then $delta(B, 1) = A$, so $hat(delta)(A, w) = A$. By IH, $|x|_1$ is odd, and since $a = 1$, we have $|w|_1 = |x|_1 + 1 =$ even.

*Conclusion:* By induction, the claim holds for all strings $w in {0, 1}^*$. Since $B$ is the only accepting state, the DFA accepts exactly the strings $w$ with $hat(delta)(A, w) = B$, which by our claim are exactly the strings with an odd number of 1's. Therefore, $L = { w in {0, 1}^* | |w|_1 equiv 1 mod 2 }$.



#pagebreak()
= Exercise RL1.7. Proving properties of transition functions.

We defined $hat(delta)$ by breaking the input string into any string followed by a single symbol (in the inductive part, Equation 2.1). However, we informally thing of $hat(delta)$ as describing what happens along a path with a certain string of labels, and if so, then it should not matter how we break the input string in the definition of $hat(delta)$.

== Show that in fact $hat(delta)(q, x y) = hat(delta)(hat(delta)(q, x), y)$ for any state $q$ and string $x$ and $y$. _Hint_: Perform an induction on $|y|$.
*Claim:* For any state $q$ and strings $x, y in Sigma^*$, we have $hat(delta)(q, x y) = hat(delta)(hat(delta)(q, x), y)$.

*Base Case:* $|y| = 0$, i.e., $y = epsilon$ (empty string).

We need to show that $hat(delta)(q, x epsilon) = hat(delta)(hat(delta)(q, x), epsilon)$.

Left side: $hat(delta)(q, x epsilon) = hat(delta)(q, x)$ by the definition of string concatenation.

Right side: $hat(delta)(hat(delta)(q, x), epsilon) = hat(delta)(q, x)$ by the base case of the definition of $hat(delta)$ (i.e., $hat(delta)(q', epsilon) = q'$ for any state $q'$).

Therefore, both sides are equal.

*Inductive Step:* Assume the claim holds for all strings $y$ with $|y| = n$. Consider a string $y$ with $|y| = n + 1$. We can write $y = z a$ where $|z| = n$ and $a in Sigma$ is a single symbol.

We need to show that $hat(delta)(q, x y) = hat(delta)(hat(delta)(q, x), y)$.

Starting with the left side:
$
hat(delta)(q, x y) &= hat(delta)(q, x (z a)) \
&= hat(delta)(q, (x z) a) quad "by associativity of concatenation" \
&= delta(hat(delta)(q, x z), a) quad "by Equation 2.1" \
&= delta(hat(delta)(hat(delta)(q, x), z), a) quad "by inductive hypothesis with" y = z \
&= hat(delta)(hat(delta)(q, x), z a) quad "by Equation 2.1" \
&= hat(delta)(hat(delta)(q, x), y) quad "since" y = z a
$

Therefore, the claim holds for $|y| = n + 1$.

*Conclusion:* The claim holds for all strings $y in Sigma^*$. Therefore, $hat(delta)(q, x y) = hat(delta)(hat(delta)(q, x), y)$ for any state $q$ and strings $x, y in Sigma^*$.



#pagebreak()
= Exercise RL1.8. Testing equivalence of DFA.
A naïve teacher provides the following exercise "construct a DFA for a coffee machine that only accepts the following behaviour: choose coffee (c) or tea (t), pay one dollar (\$), and confirm your beverage choice". Students Alice, Bob and Charlie come out with the below DFA as possible solutions.

#align(center, [
    #grid(columns: 3, gutter: 48pt, 
        raw-render(height: 30%, ```
            digraph {
                rankdir=TB
                node [shape = circle]
                g [shape=point, width=0]
                s[label="s_0"]
                s1[label="s_1"]
                s2[label="s_2"]
                s3[label="s_3"]
                s4[label="s_4"]
                s5[label="s_5", shape=doublecircle]
                s6[label="s_6", shape=doublecircle]
                g -> s
                s -> s1[label="c"]
                s1 -> s3[label="\$"]
                s3 -> s5[label="c"]
                s -> s2[label="t"]
                s2 -> s4[label="\$"]
                s4 -> s6[label="t"]
            }
        ```),
        raw-render(height: 30%, ```
            digraph {
                rankdir=TB
                node [shape = circle]
                g [shape=point, width=0]
                s[label="s'_0"]
                s1[label="s'_1"]
                s2[label="s'_2"]
                s3[label="s'_3"]
                s4[label="s'_4"]
                s5[label="s'_5", shape=doublecircle]
                g -> s
                s -> s1[label="c"]
                s1 -> s3[label="\$"]
                s3 -> s5[label="c"]
                s -> s2[label="t"]
                s2 -> s4[label="\$"]
                s4 -> s5[label="t"]
            }
        ```),
        raw-render(height: 30%, ```
            digraph {
                rankdir=TB
                node [shape = circle]
                g [shape=point, width=0]
                s[label="s''_0"]
                s1[label="s''_1"]
                s2[label="s''_2"]
                s3[label="s''_3", shape=doublecircle]
                g -> s
                s -> s1[label="c, t"]
                s1 -> s2[label="\$"]
                s2 -> s3[label="c, t"]
            }
        ```)
    )
])




== Are those DFAs language-equivalent? Find out by applying the algorithm seen in class for testing equivalence of DFA.
*Initial partition:*
- $G_1 = \{s_5, s_6, s'_5, s''_3\}$ (all accepting states)
- $G_2 = \{s_0, s_1, s_2, s_3, s_4, s'_0, s'_1, s'_2, s'_3, s'_4, s''_0, s''_1, s''_2\}$ (all non-accepting states)

*Round 1: Check if $G_1$ needs to be split*

No states in $G_1$ have outgoing transitions (they are all accepting states with no further transitions defined), so $G_1$ cannot be split.

*Round 2: Check if $G_2$ needs to be split*

Consider state $s_3$ in $G_2$: it has transition $s_3 -->^c s_5$ where $s_5 in G_1$.

Challenge: "Can you go to $G_1$ with label $c$?"
- $s_3$ can go to $G_1$ with $c$ (to $s_5$)
- $s_4$ cannot go to $G_1$ with $c$ (only has transition with $t$)
- $s'_3$ can go to $G_1$ with $c$ (to $s'_5$)
- $s'_4$ cannot go to $G_1$ with $c$ (only has transition with $t$)
- $s''_2$ can go to $G_1$ with $c$ (to $s''_3$)

Split $G_2$ into:
- $G_(2a) = \{s_3, s'_3, s''_2\}$ (can reply to challenge)
- $G_(2b) = \{s_0, s_1, s_2, s_4, s'_0, s'_1, s'_2, s'_4, s''_0, s''_1\}$ (cannot reply)

*Round 3: Check further splits*

Consider state $s_4$ in $G_(2b)$: it has transition $s_4 -->^t s_6$ where $s_6 in G_1$.

Challenge: "Can you go to $G_1$ with label $t$?"
- $s_4$ can go to $G_1$ with $t$ (to $s_6$)
- $s'_4$ can go to $G_1$ with $t$ (to $s'_5$)
- $s''_2$ can go to $G_1$ with $t$ (to $s''_3$)

But $s''_2$ is already in $G_(2a)$, so check within $G_(2b)$:
- States in $G_(2b)$ that can reach $G_1$ with $t$: $s_4, s'_4$
- States that cannot: $s_0, s_1, s_2, s'_0, s'_1, s'_2, s''_0, s''_1$

Split $G_(2b)$ into:
- $G_(2b 1) = \{s_4, s'_4\}$ (can reach $G_1$ with $t$)
- $G_(2b 2) = \{s_0, s_1, s_2, s'_0, s'_1, s'_2, s''_0, s''_1\}$ (cannot)

*Round 4: Continue splitting*

Consider state $s_1$ in $G_(2b 2)$: it has transition $s_1 -->^"$" s_3$ where $s_3 in G_(2a)$.

Challenge: "Can you go to $G_(2a)$ with label `$`?"
- $s_1$ goes to $s_3 in G_(2a)$ with `$`
- $s'_1$ goes to $s'_3 in G_(2a)$ with `$`
- $s''_1$ goes to $s''_2 in G_(2a)$ with `$`
- $s_0, s_2, s'_0, s'_2, s''_0$ do not have `$` transitions to $G_(2a)$

Actually, continuing this analysis shows that $s_2, s'_2$ transition to $G_(2b 1)$ with `$`, not to $G_(2a)$.

After continuing the algorithm systematically, we eventually reach a stable partition where:
- Initial states $s_0$ and $s'_0$ remain in the same group
- Initial state $s''_0$ is in a different group

*Conclusion:*

- Alice's DFA and Bob's DFA are equivalent.
- Charlie's DFA is not equivalent to Alice's or Bob's DFAs. Charlie's DFA accepts `c$c`, `c$t`, `t$t` and `t$c`, while Alice's and Bob's only accept `c$c` and `t$t`.


