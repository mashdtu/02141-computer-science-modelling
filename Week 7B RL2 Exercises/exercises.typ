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

#let title = "Regular Languages 2"
#let subtitle = "Non-Deterministic Finite Automata"
#let subject = "02141 Computer Science Modelling"
#let date = "February 13th, 2026"

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


= Building and Understanding NFAs
Give non-deterministic finite automata to accept the following languages. Try to take advantage of non-determinism as much as possible.

== \* The set of strings over alphabet ${0, 1, ..., 9}$ such that the final digit has appeared before.
#raw-render(width: 100%,
    ```
    digraph {
        rankdir=TB
        node [shape = circle]
        //g [shape=point, width=0]
    
        s[label=""]
        s1[label="0"]
        s2[label="1"]
        s3[label="2"]
        s4[label="3"]
        s5[label="4"]
        s6[label="5"]
        s7[label="6"]
        s8[label="7"]
        s9[label="8"]
        s10[label="9"]
        sf[label="", shape=doublecircle]

        s -> s[label="0, 1, ..., 9", tailport=n, headport=n]
        s -> s1[label="0"]
        s -> s2[label="1"]
        s -> s3[label="2"]
        s -> s4[label="3"]
        s -> s5[label="4"]
        s -> s6[label="5"]
        s -> s7[label="6"]
        s -> s8[label="7"]
        s -> s9[label="8"]
        s -> s10[label="9"]

        s1 -> s1[label="{0, 1, ..., 9} \\ 0", math=true]
        s2 -> s2[label="{0, 1, ..., 9} \\ 1", math=true]
        s3 -> s3[label="{0, 1, ..., 9} \\ 2", math=true]
        s4 -> s4[label="{0, 1, ..., 9} \\ 3", math=true]
        s5 -> s5[label="{0, 1, ..., 9} \\ 4", math=true]
        s6 -> s6[label="{0, 1, ..., 9} \\ 5", math=true]
        s7 -> s7[label="{0, 1, ..., 9} \\ 6", math=true]
        s8 -> s8[label="{0, 1, ..., 9} \\ 7", math=true]
        s9 -> s9[label="{0, 1, ..., 9} \\ 8", math=true]
        s10 -> s10[label="{0, 1, ..., 9} \\ 9", math=true]

        s1 -> sf[label="0"]
        s2 -> sf[label="1"]
        s3 -> sf[label="2"]
        s4 -> sf[label="3"]
        s5 -> sf[label="4"]
        s6 -> sf[label="5"]
        s7 -> sf[label="6"]
        s8 -> sf[label="7"]
        s9 -> sf[label="8"]
        s10 -> sf[label="9"]
    }
```)



== The set of strings over alphabet ${0, 1, ..., 9}$ such that the final digit has _not_ appeared before.
#raw-render(width: 100%,
    ```
    digraph {
        rankdir=TB
        node [shape = circle]
        //g [shape=point, width=0]
    
        s[label=""]
        s1[label="0"]
        s2[label="1"]
        s3[label="2"]
        s4[label="3"]
        s5[label="4"]
        s6[label="5"]
        s7[label="6"]
        s8[label="7"]
        s9[label="8"]
        s10[label="9"]
        sf[label="", shape=doublecircle]

        s -> s[label="0, 1, ..., 9", tailport=n, headport=n]
        s -> s1[label="{0, 1, ..., 9} \\ 0"]
        s -> s2[label="{0, 1, ..., 9} \\ 1"]
        s -> s3[label="{0, 1, ..., 9} \\ 2"]
        s -> s4[label="{0, 1, ..., 9} \\ 3"]
        s -> s5[label="{0, 1, ..., 9} \\ 4"]
        s -> s6[label="{0, 1, ..., 9} \\ 5"]
        s -> s7[label="{0, 1, ..., 9} \\ 6"]
        s -> s8[label="{0, 1, ..., 9} \\ 7"]
        s -> s9[label="{0, 1, ..., 9} \\ 8"]
        s -> s10[label="{0, 1, ..., 9} \\ 9"]

        s1 -> sf[label="0", math=true]
        s2 -> sf[label="1", math=true]
        s3 -> sf[label="2", math=true]
        s4 -> sf[label="3", math=true]
        s5 -> sf[label="4", math=true]
        s6 -> sf[label="5", math=true]
        s7 -> sf[label="6", math=true]
        s8 -> sf[label="7", math=true]
        s9 -> sf[label="8", math=true]
        s10 -> sf[label="9", math=true]

        s1 -> s1[label="{0, 1, ..., 9} \\ 0"]
        s2 -> s2[label="{0, 1, ..., 9} \\ 1"]
        s3 -> s3[label="{0, 1, ..., 9} \\ 2"]
        s4 -> s4[label="{0, 1, ..., 9} \\ 3"]
        s5 -> s5[label="{0, 1, ..., 9} \\ 4"]
        s6 -> s6[label="{0, 1, ..., 9} \\ 5"]
        s7 -> s7[label="{0, 1, ..., 9} \\ 6"]
        s8 -> s8[label="{0, 1, ..., 9} \\ 7"]
        s9 -> s9[label="{0, 1, ..., 9} \\ 8"]
        s10 -> s10[label="{0, 1, ..., 9} \\ 9"]
    }
```)



== The set of strings of $0$'s and $1$'s such that there are two $0$'s seperated by a number of positions that is a multiple of $4$. Note that $0$ is an allowable multiple of $4$.
#raw-render(width: 100%,
    ```
    digraph {
        rankdir=LR
        node [shape = circle]
        g [label="", color=invis]

        s[label=""]
        s1[label=""]
        s2[label=""]
        s3[label=""]
        s4[label=""]
        sf[label="", shape=doublecircle]

        g -> s
        s -> s[label="0, 1"]
        s -> s1[label="0"]
        s1 -> s2[label="0, 1"]
        s2 -> s3[label="0, 1"]
        s3 -> s4[label="0, 1"]
        s4 -> s1[label="0, 1"]
        s1 -> sf[label="0"]
        sf -> sf[label="0, 1"]
    }
```)




#pagebreak()
= NFAs to DFAs
#table( columns: (15%, 15%, 15%),
    [], [0], [1],
    [$-> p$], [${p, q}$], [${p}$],
    [$q$], [${r, s}$], [${t}$],
    [$r$], [${p, r}$], [${t}$],
    [$*s$], [$emptyset$], [$emptyset$],
    [$*t$], [$emptyset$], [$emptyset$]
)

== \! Convert the above NFA to a DFA and informally describe the language it accepts.
The NFA can be modelled:
#raw-render(width: 85%,
    ```
    digraph {
        rankdir=LR
        node [shape = circle]
        g [label="", color=invis]

        p[label="p"]
        q[label="q"]
        r[label="r"]
        s[label="s", shape=doublecircle]
        t[label="t", shape=doublecircle]

        g -> p
        p -> p[label="0, 1"]
        p -> q[label="0"]
        q -> r[label="0"]
        q -> s[label="0"]
        q -> t[label="1"]
        r -> p[label="0"]
        r -> r[label="0"]
        r -> t[label="1"]
    }
```)

Informally, the NFA accepts the following languages:
- Any string of `0`'s and `1`'s ending with `00` -- where the NFA finishes in state $s$.
- Any string of `0`'s and `1`'s ending with `01` -- where the NFA finishes in state $t$.

The NFA is converted to a DFA by analysing the transition table. For $p$:
- If `0`, then $p -> {p, q}$.
- If `1`, then $p -> p$.

Two nodes $p$ and ${p, q}$ are created, with a transition $p$ to ${p, q}$ with label `0` and a transition from $p$ to $p$ with label `1`. We analyse the node ${p, q}$:
- If `0`, then $p -> {p, q}$ and $q -> {r, s}$. Thus ${p, q} -> {p, q, r, s}$.
- If `1`, then $p -> p$ and $q -> t$. Thus ${p, q} -> {p, t}$.

Two nodes ${p, q, r, s}$ and ${p, t}$ are created, with a transition from ${p, q}$ to ${p, q, r, s}$ with label `0` and a transition from ${p, q}$ to ${p, t}$ with label `1`. We have two new nodes to analyse, we start with ${p, q, r, s}$.
- If `0`, then $p -> {p, q}$, $q -> {r, s}$, $r -> {p, r}$ and $s -> emptyset$. Thus ${p, q, r, s} -> {p, q, r, s}$.
- If `1`, then $p -> p$, $q -> t$, $r -> t$ and $s -> emptyset$. Thus ${p, q, r, s} -> {p, t}$.

We draw a transition from ${p, q, r, s}$ to itself with label `0`, along with a transition from ${p, q, r, s}$ to ${p, t}$ with label `1`. We analyse the node ${p, t}$.
- If `0`, then $p -> {p, q}$ and $t -> emptyset$. Thus ${p, t} -> {p, q}$.
- If `1`, then $p -> p$ and $t -> emptyset$. Thus ${p, t} -> p$.

We draw a transition from ${p, t}$ to ${p, q}$ with label `0`, and a transition from ${p, t}$ to $p$ with label `1`. Following this analysis, we produce the following DFA model.

#raw-render(width: 85%,
    ```
    digraph {
        rankdir=LR
        node [shape = circle]
        g [label="", color=invis]

        p[label="p"]
        pq[label="{p,q}"]
        pt[label="{p,t}", shape=doublecircle]
        pqrs[label="{p,q,r,s}", shape=doublecircle]

        g -> p
        p -> pq[label="0"]
        p -> p[label="1"]
        pq -> pqrs[label="0"]
        pq -> pt[label="1"]
        pqrs -> pqrs[label="0"]
        pqrs -> pt[label="1"]
        pt -> pq[label="0"]
        pt -> p[label="1"]
    }
```)






= On $epsilon$-NFAs I

Consider the folllowing $epsilon$-NFA.

#table( columns: (9%, 9%, 9%, 9%, 9%),
    [],         [$epsilon$],        [$a$],              [$b$],              [$c$],
    [$-> p$],   [$emptyset$],       [${p}$],            [${q}$],            [${r}$],
    [$q$],      [${p}$],            [${q}$],            [${r}$],            [$emptyset$],
    [$*r$],     [${q}$],            [${r}$],            [$emptyset$],       [${p}$],
)

== Compute the $epsilon$-closure of each state.


== Give all the strings of length three or less accepted by the automaton.


== Convert the automaton to a DFA.




= On $epsilon$-NFAs II
Design $epsilon$-NFAs for the following languages. Try to use $epsilon$-transitions to simplify your design.

== The set of strings consistion of zero or more $a$'s, followed by zero or more $b$'s, followed by zero or more $c$'s.


== \! The set of strings the consist of either $01$ repeated one or more times or $010$ repeated one or more times.


== \! The set of strings $0$'s and $1$'s such that at least one of the last ten positions is a $1$.




= Correctness of the subset construction
In class we have seen the proof of correctness of the subset construction, i..e. that the language of an NFA $N = (Q, Sigma, delta_N, q_0, F)$ is the same as the language of the DFA $D = Q_D, Sigma, delta_D, {q_0}, F_D$ obtained by the subset of construction. The key property proven is
$
    forall q in Q, w in Sigma^* : delta^*_N (q, w) = delta^*_D ({q}, w).
$ 

== Prove this property again on your own. _Hint_: Use induction on the length of $w$ or alternatively on the structure of $w$.
