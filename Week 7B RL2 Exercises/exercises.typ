#import "@preview/diagraph:0.3.6": *
#import "@preview/chic-hdr:0.5.0": *
#import "@preview/rexllent:0.4.0": *

#show heading: set block(above: 2em)
#show heading: set block(below: 1em)
#show link: it => underline(text(fill: blue)[#it])
#show selector(<nonumber>): set heading(numbering: none)

#let first-heading = state("first-heading", true)
#show heading.where(level: 1): it => {
    context if first-heading.get() {
        first-heading.update(false)
        it
    } else {
        pagebreak(weak: true) + it
    }
}

#let numberingH(c) = {
    if c.numbering != none {
        return numbering(c.numbering, ..counter(heading).at(c.location()))
    }
    return ""
}

#let currentH(level) = {
    let elems = query(selector(heading.where(level: level)).after(here()))

    if elems.len() != 0 and elems.first().location().page() == here().page() {
        return [#numberingH(elems.first()) #elems.first().body]
    } else {
        elems = query(selector(heading.where(level: level)).before(here()))
        if elems.len() != 0 {
            return [#numberingH(elems.last()) #elems.last().body]
        }
    }
    return ""
}

#set page(
    paper: "a4",
    margin: (x: 2.5cm, y: 2.5cm),
    number-align: right,
)

#set par(
    justify: true,
)

#set text(
    font: "New Computer Modern",
    size: 12pt,
)

#set heading(
    numbering: "1.1 ",
)

#let ansline = line(
    start: (0%, 0%),
    end: (100%, 0%),
    stroke: (thickness: 1pt, dash: "dashed"),
)

#let title = "Regular Languages 2"
#let subtitle = "Non-Deterministic Finite Automata"
#let subject = "0241 Computer Science Modelling"
#let date = "February 13th, 2026"

#let author = (if read("../.secret").trim() == "" { "name" } else { read("../.secret").trim() },)

#align(center)[
    #text(32pt)[#smallcaps(title)] \ #text(18pt)[#subtitle] \ #text(fill: black.lighten(25%), [#subject])
]

#{
    grid(
        columns: (1fr,) * author.len(),
        column-gutter: -120pt,
        ..author.map(a => align(center)[#a])
    )
}

#align(center)[
    #date
]


#outline()
#pagebreak()

#counter(page).update(1)
#show: chic.with(
    chic-footer(
        right-side: "Page " + context str(counter(page).get().first()) + " of " + str(counter(page).final().first()),
    ),
)
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
The $epsilon$-closure of each state is the set of states which can be "reached" using en $epsilon$-transition, including the state itself. Remember, that if a state `A` has an $epsilon$-transition to a state `B`, and state `B` has an $epsilon$-transition to state `C`, then state `A` also has an epsilon transition to state `C`. I.e. the $epsilon$-closure is recursively defined and includes the $epsilon$-closure of each state within the $epsilon$-closure. Analysing the $epsilon$-NFA transition table:
$
    epsilon"-closure"(p) &= {p}
    quad quad
    epsilon"-closure"(q) &= {p, q}
    quad quad
    epsilon"-closure"(r) &= {p, q, r}
$


== Give all the strings of length three or less accepted by the automaton.
The NFA can be modelled:
#raw-render(width: 45%,
    ```
    digraph {
        rankdir=LR
        node [shape = circle]
        g [label="", color=invis]

        p[label="p"]
        q[label="q"]
        r[label="r", shape=doublecircle]

        g -> p
        p -> p[label="a"]
        p -> q[label="b"]
        p -> r[label="c"]
        q -> p[label=epsilon]
        q -> q[label="a"]
        q -> r[label="b"]
        r -> q[label=epsilon]
        r -> r[label="a"]
        r -> p[label="c"]
    }
```)

Informally, the automaton accepts the following languages:
- Any string of `a`'s `b`'s and `c`'s with at least one `c`.
- Any string of `a`'s `b`'s and `c`'s with at least two `b`'s.

Formally, this is written as:
```
^([abc]*c[abc]*|[abc]*b[abc]*b[abc]*)$
```

All the strings of length three or less can be found by matching each 3-character combination of `a`'s, `b`'s and `c`'s with the regular expression. This is done using an `F#` script#footnote([The `F#` script can be viewed in Appendix A.]). The script yields the following output:
```
c ac bb bc ca cb cc aac abb abc aca acb acc bab bac bba bbb bbc bca bcb bcc caa cab cac cba cbb cbc cca ccb ccc
```
These are the 30 strings of length $<= 3$, accepted by the automaton.


== Convert the automaton to a DFA.
We analyse the transition table, starting with the initial state $p$.
- If `a`, then $p -> epsilon"-closure"({p}) = {p}$.
- If `b`, then $p -> epsilon"-closure"({q}) = {p, q}$.
- If `c`, then $p -> epsilon"-closure"({r}) = {p, q, r}$.

We add three new states $p$, ${p, q}$ and ${p, q, r}$. We analyse ${p, q}$.
- If `a`, then ${p, q} -> epsilon"-closure"({p, q}) = {p, q}$.
- If `b`, then ${p, q} -> epsilon"-closure"({q, r}) = {p, q, r}$.
- If `c`, then ${p, q} -> epsilon"-closure"({r}) = {p, q, r}$.

We analyse ${p, q, r}$.
- If `a`, then ${p, q, r} -> epsilon"-closure"({p, q, r}) = {p, q, r}$.
- If `b`, then ${p, q, r} -> epsilon"-closure"({q, r}) = {p, q, r}$.
- If `c`, then ${p, q, r} -> epsilon"-closure"({p, r}) = {p, q, r}$.

Following this analysis, we produce the following DFA model.

#grid(columns: (1fr, 1fr),
    [
        #raw-render(width: 90%,
            ```
            digraph {
                rankdir=LR
                node [shape = circle]
                g [label="", color=invis]

                p[label="p"]
                pq[label="{p,q}"]
                pqr[label="{p,q,r}", shape=doublecircle]

                p -> p[label="a"]
                p -> pq[label="b"]
                p -> pqr[label="c"]

                pq -> pq[label="a"]
                pq -> pqr[label="b, c"]

                pqr -> pqr[label="a, b, c"]
            }
        ```)
    ],
    [
        #text(size: 10pt, [
            #table( columns: (1fr, 1fr, 1fr, 1fr),
                [],             [`a`],              [`b`],              [`c`],
                [$-> p$],       [${p}$],            [${p, q}$],         [${p, q, r}$],
                [${p, q}$],     [${p, q}$],         [${p, q, r}$],      [${p, q, r}$],
                [$*{p, q, r}$], [${p, q, r}$],      [${p, q, r}$],      [${p, q, r}$]
            )
        ])
    ]
)



= On $epsilon$-NFAs II
Design $epsilon$-NFAs for the following languages. Try to use $epsilon$-transitions to simplify your design.

== The set of strings consistion of zero or more $a$'s, followed by zero or more $b$'s, followed by zero or more $c$'s.
#grid(columns: (1fr, 1fr),
    [
        #raw-render(width: 90%,
            ```
            digraph {
                rankdir=LR
                node [shape = circle]
                g [label="", color=invis]

                p[label="p"]
                q[label="q"]
                r[label="r", shape=doublecircle]

                g -> p
                p -> p[label="a"]
                q -> q[label="b"]
                r -> r[label="c"]
                p -> q[label=epsilon]
                q -> r[label=epsilon]
            }
        ```)
    ],
    [
        #text(size: 10pt, [
            #table( columns: (1fr, 1fr, 1fr, 1fr, 1fr),
                [],         [$epsilon$],    [$a$],              [$b$],              [$c$],
                [$-> p$],   [${q}$],        [${p}$],            [$emptyset$],       [$emptyset$],
                [$q$],      [${r}$],        [$emptyset$],       [${q}$],            [$emptyset$],
                [$*r$],     [$emptyset$],   [$emptyset$],       [$emptyset$],       [${r}$]
            )
        ])
    ]
)


== \! The set of strings that consist of either $01$ repeated one or more times or $010$ repeated one or more times.
This language can be split in two. (1) The set of strings that consist of $01$ repeated one or more times. And (2) The set of strings that consist of $010$ repeated one or more times. An NFA that accepts language (1) can be illustrated:
#grid(columns: (1fr, 1fr),
    [
        #raw-render(width: 90%,
            ```
            digraph {
                rankdir=LR
                node [shape = circle]
                g [label="", color=invis]

                p1[label="p_1"]
                p2[label="p_2"]
                p3[label="p_3", shape=doublecircle]

                g -> p1
                p1 -> p2[label="0"]
                p2 -> p3[label="1"]
                p3 -> p1[label=epsilon]
            }
        ```)
    ],
    [
        #text(size: 10pt, [
            #table( columns: (1fr, 1fr, 1fr, 1fr),
                [],             [$epsilon$],        [`0`],              [`1`],
                [$-> p_1$],     [$emptyset$],       [${p_2}$],          [$emptyset$],
                [$p_2$],        [$emptyset$],       [$emptyset$],       [${p_3}$],
                [$*p_3$],       [${p_1}$],          [$emptyset$],       [$emptyset$]
            )
        ])
    ]
)

An NFA that accepts language (2) can be illustrated:
#grid(columns: (1fr, 1fr),
    [
        #raw-render(width: 90%,
            ```
            digraph {
                rankdir=LR
                node [shape = circle]
                g [label="", color=invis]

                q1[label="q_1"]
                q2[label="q_2"]
                q3[label="q_3"]
                q4[label="q_4", shape=doublecircle]

                g -> q1
                q1 -> q2[label="0"]
                q2 -> q3[label="1"]
                q3 -> q4[label="0"]
                q4 -> q1[label=epsilon]
            }
        ```)
    ],
    [
        #text(size: 10pt, [
            #table( columns: (1fr, 1fr, 1fr, 1fr),
                [],             [$epsilon$],        [`0`],              [`1`],
                [$-> q_1$],     [$emptyset$],       [${q_2}$],          [$emptyset$],
                [$q_2$],        [$emptyset$],       [$emptyset$],       [${q_3}$],
                [$q_3$],        [$emptyset$],       [${q_4}$],          [$emptyset$],
                [$*q_4$],       [${q_1}$],          [$emptyset$],       [$emptyset$]
            )
        ])
    ]
)

The two automata are combined with a new initial state $s$
#grid(columns: (1fr, 1fr),
    [
        #raw-render(width: 90%,
            ```
            digraph {
                rankdir=LR
                node [shape = circle]
                g [label="", color=invis]

                s [label="s"]
                p1 [label="p_1"]
                p2 [label="p_2"]
                p3 [label="p_3", shape=doublecircle]
                q1 [label="q_1"]
                q2 [label="q_2"]
                q3 [label="q_3"]
                q4 [label="q_4", shape=doublecircle]

                s -> p1 [label=epsilon]
                s -> q1 [label=epsilon]

                p1 -> p2 [label="0"]
                p2 -> p3 [label="1"]
                p3 -> p1 [label=epsilon]

                q1 -> q2 [label="0"]
                q2 -> q3 [label="1"]
                q3 -> q4 [label="0"]
                q4 -> q1 [label=epsilon]
            }
        ```)
    ],
    [
        #text(size: 10pt, [
            #table( columns: (1fr, 1fr, 1fr, 1fr),
                [],             [$epsilon$],        [`0`],              [`1`],
                [$-> s$],       [${p_1, q_1}$],     [$emptyset$],       [$emptyset$],
                [$p_1$],        [$emptyset$],       [${p_2}$],          [$emptyset$],
                [$p_2$],        [$emptyset$],       [$emptyset$],       [${p_3}$],
                [$*p_3$],       [${p_1}$],          [$emptyset$],       [$emptyset$],
                [$q_1$],        [$emptyset$],       [${q_2}$],          [$emptyset$],
                [$q_2$],        [$emptyset$],       [$emptyset$],       [${q_3}$],
                [$q_3$],        [$emptyset$],       [${q_4}$],          [$emptyset$],
                [$*q_4$],       [${q_1}$],          [$emptyset$],       [$emptyset$]
            )
        ])
    ]
)



== \! The set of strings $0$'s and $1$'s such that at least one of the last ten positions is a $1$.
#raw-render(width: 100%,
    ```
digraph {
    rankdir=TB
    node [shape = circle]

    // States
    {
        rank=same
        start [label="", shape=point, color=invis]
        r0 [label="r0"]
        r1 [label="r1", shape=doublecircle]
        r2 [label="r2", shape=doublecircle]
        r3 [label="r3", shape=doublecircle]
        r4 [label="r4", shape=doublecircle]
    }

    {
        rank=same
        r5 [label="r5", shape=doublecircle]
        r6 [label="r6", shape=doublecircle]
        r7 [label="r7", shape=doublecircle]
        r8 [label="r8", shape=doublecircle]
        r9 [label="r9", shape=doublecircle]
        r10 [label="r10", shape=doublecircle]
    }

    // Start
    start -> r0

    // Transitions
    r0 -> r0 [label="0,1", tailport=ne, headport=_]
    r0 -> r1 [label="1"]
    r1 -> r2 [label="0,1"]
    r2 -> r3 [label="0,1"]
    r3 -> r4 [label="0,1"]
    r4 -> r5 [label="0,1"]
    
    r6 -> r5 [label="0,1", dir=back]
    r7 -> r6 [label="0,1", dir=back]
    r8 -> r7 [label="0,1", dir=back]
    r9 -> r8 [label="0,1", dir=back]
    r10 -> r9 [label="0,1", dir=back]
}
```)

#text(size: 10pt, [
    #table( columns: (1fr, 1fr, 1fr),
        [],            [`0`],           [`1`],
        [$-> r_0$],    [${r_0}$],       [${r_0, r_1}$],
        [$*r_1$],      [${r_2}$],       [${r_2}$],
        [$*r_2$],      [${r_3}$],       [${r_3}$],
        [$*r_3$],      [${r_4}$],       [${r_4}$],
        [$*r_4$],      [${r_5}$],       [${r_5}$],
        [$*r_5$],      [${r_6}$],       [${r_6}$],
        [$*r_6$],      [${r_7}$],       [${r_7}$],
        [$*r_7$],      [${r_8}$],       [${r_8}$],
        [$*r_8$],      [${r_9}$],       [${r_9}$],
        [$*r_9$],      [${r_10}$],      [${r_10}$],
        [$*r_10$],     [$emptyset$],    [$emptyset$]
    )
])




= Correctness of the subset construction
In class we have seen the proof of correctness of the subset construction, i.e. that the language of an NFA $N = (Q, Sigma, delta_N, q_0, F)$ is the same as the language of the DFA $D = Q_D, Sigma, delta_D, {q_0}, F_D$ obtained by the subset of construction. The key property proven is
$
    forall q in Q, w in Sigma^* : delta^*_N (q, w) = delta^*_D ({q}, w).
$ 

== Prove this property again on your own. _Hint_: Use induction on the length of $w$ or alternatively on the structure of $w$.

*Proof by induction on the length of $w$:*

*Base case:* $|w| = 0$, so $w = epsilon$.
- $delta^*_N(q, epsilon) = q$ (definition of extended transition function)
- $delta^*_D({q}, epsilon) = {q}$ (definition of extended transition function)
- Therefore the property holds.

*Inductive case:* Assume the property holds for all strings of length $n$. Let $w = w'a$ where $|w'| = n$ and $a in Sigma$.

By the inductive hypothesis, we have:
$
    delta^*_N(q, w') = delta^*_D({q}, w')
$

Let $S = delta^*_D({q}, w')$. We need to show:
$
    delta^*_N(q, w'a) = delta^*_D({q}, w'a)
$

For the NFA:
$
    delta^*_N(q, w'a) = union_(p in delta^*_N(q, w')) delta_N(p, a)
                      = union_(p in S) delta_N(p, a)
$

For the DFA:
$
    delta^*_D({q}, w'a) = delta_D(delta^*_D({q}, w'), a)
                        = delta_D(S, a)
                        = union_(p in S) delta_N(p, a)
$

Since both equal $union_(p in S) delta_N(p, a)$, we have $delta^*_N(q, w'a) = delta^*_D({q}, w'a)$, completing the induction.





#pagebreak()
= Appendix A: F\# Regex Matcher Script <nonumber>
#raw(read("code/regex_matcher.fs"), lang: "fs", block: true)
